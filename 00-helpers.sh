#!/usr/bin/env bash

_swordfish2_ID="4c4c4544-0050-4a10-8058-b2c04f594433"
AconfNeedProgram dmidecode dmidecode N
_system_id="$(sudo dmidecode -s system-uuid)"

_gpus=$(lspci -m -d ::03xx | awk -F '\"|\" \"|\\(' \
	'/"Display|"3D|"VGA/ {
		a[$0] = $1 " " $3 " " ($(NF-1) ~ /^$|^Device [[:xdigit:]]+$/ ? $4 : $(NF-1))
	}
	END { for (i in a) {
		if (!seen[a[i]]++) {
			sub("^[^ ]+ ", "", a[i]);
			print a[i]
		}
	}}')

if [[ "$_system_id" == "$_swordfish2_ID" ]]; then
	_hostname="swordfish2"
else
	_hostname="$HOST"
fi

function IgnorePathsExcept() {
	# Ignore all path in given directory (first parameter)
	# that do not math the given white list (second parameter)

	local search_dir=$1
	shift
	local white_list=("$@")
	local find_args=()
	local ignore_path
	for ignore_path in "${white_list[@]}"; do
		local base="$ignore_path"
		# Add all base paths to the argument list as well otherwise
		# -prune will prevent us from reaching the whitelisted files.
		while [ "$base" != '.' ]; do
			find_args+=(-path "$search_dir/$base" -o)
			base="$(dirname "$base")"
		done
	done
	# Find everything except given whitelist and the directory
	# searched from.
	find "$search_dir" -not \( "${find_args[@]}" -path "$search_dir" \) -prune |
		while read file; do
			if [[ -d "$file" ]]; then
				IgnorePath "$file/*"
			else
				IgnorePath "$file"
			fi
		done
}

rm -rf "$tmp_dir"/usergroups
rm -rf "$tmp_dir"/groups

# Add user to /etc/{passwd,shadow} and corresponding group.
function AddUser() {
	local username=$1
	local password=$2
	local uid=$3
	local gid=$4
	local gpassword=$5
	local desc=$6
	local home=$7
	local shell=$8
	local groups=$9
	local expire=${10}

	if [[ -z "$password" ]]; then
		FatalError 'Attempting to create user with blank password\n'
	fi

	AddGroup "$username" "$gpassword" "$gid"

	mkdir -p "$output_dir"/files/etc
	printf '%s:%s:%d:%d:%s:%s:%s\n' "$username" x "$uid" "$gid" "$desc" "$home" "$shell" >>"$output_dir"/files/etc/passwd
	printf '%s:%s::::::%s:\n' "$username" "$password" "$expire" >>"$output_dir"/files/etc/shadow

	mkdir -p "$tmp_dir"/usergroups

	local grouparr=()
	IFS=',' read -ra grouparr <<<"$groups"

	local group
	for group in "${grouparr[@]}"; do
		printf "%s\n" "$username" >>"$tmp_dir"/usergroups/"$group"
	done
}

# Add group to /etc/{group,gshadow}.
function AddGroup() {
	local name=$1
	local password=$2
	local gid=$3

	mkdir -p "$tmp_dir"/groups
	printf '%s:%s:%d:\n' "$name" x "$gid" >>"$tmp_dir"/groups/group
	printf '%s:%s::\n' "$name" "$password" >>"$tmp_dir"/groups/gshadow
}

function AddUserToGroup() {
	local user=$1
	local group=$2

	printf "%s\n" "$user" >>"$tmp_dir"/usergroups/"$group"
}

function getpassword() {
	local username=$1
	sudo grep "^$username:" /etc/shadow | cut -d : -f 2
}

# SystemdEnable
#     [--no-alias|--no-wanted-by]
#     [--name CUSTOM_NAME]
#     [--type system|user]
#     [--from-file|package] unit
#
# Enable a systemd unit file.
#
# Caveat: This will not process Also directives, as it might in theory require
# handling files from other packages. In addition you might not want to install
# both this unit and the Also unit.
#
# --no-alias and --no-wanted-by can be used to disable installing those types of
# links. This is useful if you want to just use socket and dbus activation and
# don't want the unit to start on boot.
#
# --name is to be used for parameterised units ("foo@.service"), to provide the
# parameter.
#
# --type defaults to system but can be used to override and install default user
# units in /etc/systemd/user.
#
# --from-file is used when unit file is installed by aconfmgr instead of pulled
# from a package. In this case the package name MUST be skipped. Otherwise it is
# REQUIRED.
# function SystemdEnable() {
# 	local type=system
# 	local do_alias=1 do_wanted_by=1 from_file=0
#
# 	# Parse arguments
# 	while [[ $# -gt 0 ]]; do
# 		case "$1" in
# 		--no-alias) do_alias=0 ;;
# 		--no-wanted-by) do_wanted_by=0 ;;
# 		--from-file) from_file=1 ;;
# 		--name)
# 			local name_override=$2
# 			shift 1
# 			;;
# 		--type)
# 			type=$2
# 			shift 1
# 			;;
# 		*)
# 			break
# 			;;
# 		esac
# 		shift 1
# 	done
#
# 	if [[ $from_file -eq 0 ]]; then
# 		[[ $# -ne 2 ]] && FatalError "Expected 2 arguments, got $#."
# 		local pkg="$1"
# 		local unit="$2"
# 	else
# 		[[ $# -ne 1 ]] && FatalError "Expected 1 argument, got $#."
# 		local unit="$1"
# 	fi
#
# 	if [[ "$type" != "system" && "$type" != "user" ]]; then
# 		FatalError "Unknown type ${type}"
# 	fi
#
# 	local filename="${unit##*/}"
#
# 	# Find the unit, either from package data or already added to the output
# 	# directory
# 	if [[ $from_file -eq 0 ]]; then
# 		local unit_source="$tmp_dir/systemd_helpers/$pkg/$filename"
#
# 		if [[ ! -f "$unit_source" ]]; then
# 			mkdir -p "$tmp_dir/systemd_helpers/$pkg"
# 			AconfGetPackageOriginalFile "$pkg" "$unit" >"$unit_source"
# 		fi
# 	else
# 		local unit_source="$output_dir/files/$unit"
# 	fi
#
# 	[[ ! -f "$unit_source" ]] && FatalError "$unit_source not found"
#
# 	local target
# 	local oIFS="$IFS"
# 	# Process WantedBy lines (if enabled)
# 	if [[ $do_wanted_by -eq 1 ]]; then
# 		local name="${name_override:-${filename}}"
# 		local -a wantedby
#
# 		if grep -q WantedBy= "$unit_source"; then
# 			IFS=$' \n\t'
# 			mapfile -t aliases < <(sed -nE '/^WantedBy=/ {s/^WantedBy=//; s/ /\n/gp}' "$unit_source")
# 			IFS="$oIFS"
# 			for target in "${wantedby[@]}"; do
# 				CreateLink "/etc/systemd/${type}/${target}.wants/${name}" "${unit}"
# 			done
# 		fi
# 	fi
#
# 	# Process Alias lines (if enabled)
# 	if [[ $do_alias -eq 1 ]]; then
# 		local -a aliases
#
# 		if grep -q Alias= "$unit_source"; then
# 			IFS=$' \n\t'
# 			mapfile -t aliases < <(sed -nE '/^Aliases=/ {s/^Aliases=//; s/ /\n/gp}' "$unit_source")
# 			IFS="$oIFS"
# 			for target in "${aliases[@]}"; do
# 				CreateLink "/etc/systemd/${type}/${target}" "${unit}"
# 			done
# 		fi
# 	fi
# }
#
# # SystemdMask unit-name [type]
# #
# # Mask a unit. Defaults to masking system units
# function SystemdMask() {
# 	local unit="$1"
# 	local type="${2:-system}"
#
# 	if [[ "$type" != "system" && "$type" != "user" ]]; then
# 		FatalError "Unknown type ${type}"
# 	fi
#
# 	CreateLink "/etc/systemd/${type}/${unit}" /dev/null
# }

function IsLaptop() {
	[[ $(hostnamectl chassis) == "laptop" ]] && return 0 || return 1
}
# GetNvidiaModel
#
# Ruturns the model number of a NVIDIA GPU
function GetNvidiaModel() {
	local ret
	ret=$(echo "$_gpus" | grep "NVIDIA" | sed 's/.*RTX \([0-9]*\).*/\1/')
	echo "$ret"
}

# IsIntelGPU
#
# Returns if there is a intel GPU
function IsIntelGPU() {
	echo "$_gpus" | grep -q "Intel" && return 0 || return 1
}

# PrintAppendArray()
# PrintArray "Name" "${array[@]}"
# Prints an appending array to use in downstream scripts
function PrintAppendArray() {
	local _name="${1}"
	shift
	local _array=("$@")
	echo -n "${_name}+=("
	echo -n "${_array[@]}"
	echo ")"
}

# AppendArrayInFile()
# AppendArray "File" "Name" "${array[@]}"
# Adds an line to append to an Array in a bash script
function AppendArrayInFile() {
	local _file="${1}"
	shift
	local _name="${1}"
	shift
	local _array=("$@")
	local _tmpfile
	_tmpfile="$(mktemp)"
	awk -v pattern="^$_name" \
		-v append_array="$(PrintAppendArray "$_name" "${_array[@]}")" '
			{ lines[NR] = $0 }
			$0 ~ pattern { last_match_nr =  NR }
			END {
				for (i = 1; i <= NR; i++) {
					print lines[i]
					if (i == last_match_nr) {
						print append_array
					}
				}
			}
	' "$_file" >"$_tmpfile" && mv "$_tmpfile" "$_file"
}

# CopyFileFromOutputTo SRC-PATH DST-PATH [MODE [OWNER [GROUP]]]
#
# Copies a file from the "files" subdirectory to the output,
# under a different name or path.
#
# The source path should be relative to the root of the output directory.
# The destination path is relative to the root of the output directory.
#

function CopyFileFromOutputTo() {
	local src_file="$1"
	local dst_file="$2"
	local mode="${3:-}"
	local owner="${4:-}"
	local group="${5:-}"

	if [[ "$src_file" != /* ]]; then
		ConfigWarning 'Source file path %s is not absolute.\n' \
			"$(Color C "%q" "$src_file")"
	fi

	if [[ "$dst_file" != /* && "$dst_file" != "$src_file" ]]; then
		ConfigWarning 'Target file path %s is not absolute.\n' \
			"$(Color C "%q" "$dst_file")"
	fi

	mkdir --parents "$(dirname "$output_dir"/files/"$dst_file")"

	cp --no-dereference "$output_dir"/files/"$src_file" \
		"$output_dir"/files/"$dst_file"

	SetFileProperty "$dst_file" mode "$mode"
	SetFileProperty "$dst_file" owner "$owner"
	SetFileProperty "$dst_file" group "$group"

}

# GetFilesFromOnlineTarball SRC-URL SRC-FILES STRIP DST-PATH [MODE [OWNER [GROUP]]]
#
# Downloads Tarball from an URL and extracts to a tmp folder then extracts
# folder or file from it and copies it to the output path
function GetFilesFromOnlineTarball() {
	local tarball_URL="$1"
	local src_files="$2"
	local strip_component="$3"
	local dst_path="$4"
	local mode="${5:-}"
	local owner="${6:-}"
	local group="${7:-}"

	shopt -s globstar

	if [[ "$dst_path" != /* ]]; then
		ConfigWarning 'Target file path %s is not absolute.\n' \
			"$(Color C "%q" "$dst_path")"
	fi

	mkdir --parents "$output_dir"/files/"$dst_path"

	AconfNeedProgram wget wget N
	local _dl_tmp_flolder
	_dl_tmp_folder="$(mktemp -d)"
	pushd "$_dl_tmp_folder" || OnError
	wget "$tarball_URL"
	tar --strip-component="$strip_component" -xzf "${tarball_URL##*/}" \
		-C "$output_dir"/files/"$dst_path" "${src_files}"

	for file in "$output_dir"/files"$dst_path"/**/*; do
		SetFileProperty "${file#*files}" mode "$mode"
		SetFileProperty "${file#*files}" owner "$owner"
		SetFileProperty "${file#*files}" group "$group"
	done
	popd || OnError
	rm -rf "$_dl_tmp_folder"
}
