#!/usr/bin/env bash

function AppendGroupMembers() {
	while IFS=: read -r name rest; do
		local members=()
		if [[ -f "$tmp_dir"/usergroups/"$name" ]]; then
			mapfile -t members <"$tmp_dir"/usergroups/"$name"
		fi

		local memberstr
		local oIFS=$IFS
		IFS=, memberstr="${members[*]}"
		IFS=$oIFS

		printf '%s:%s%s\n' "$name" "$rest" "$memberstr"
	done
}

AppendGroupMembers <"$tmp_dir"/groups/group >"$output_dir"/files/etc/group
AppendGroupMembers <"$tmp_dir"/groups/gshadow >"$output_dir"/files/etc/gshadow

for f in passwd shadow group gshadow; do
	cp "$output_dir"/files/etc/"$f"{,-}
	if [[ $f == *shadow ]]; then
		SetFileProperty /etc/"$f" mode 600
		SetFileProperty /etc/"$f"- mode 600
	fi
done

SetFileProperty /etc/gshadow mode ''
SetFileProperty /etc/shadow mode ''
