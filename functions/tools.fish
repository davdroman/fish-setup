function rot13
	echo $argv | tr 'A-Za-z' 'N-ZA-Mn-za-m'
end

function ytdl
	youtube-dl -i -w -c $argv
end
