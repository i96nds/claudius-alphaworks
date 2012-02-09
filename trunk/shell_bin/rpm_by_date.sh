rpm -qa --queryformat '%{installtime} %{name}-%{version}-%{release} %{installtime:date}\n' | sort -n -k 1 | sed -e 's/^[^ ]* //' | tail -80

