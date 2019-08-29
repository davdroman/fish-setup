function spminit
	switch (count $argv)
	case 0
		swift package init --type executable
	case 1
		swift package init $argv
	end
end

function spmup
	swift package update
end

function spmgen
	swift package generate-xcodeproj
end

function spmdebug
	swift build --disable-sandbox
end

function spmrelease
	swift build --disable-sandbox -c release
end
