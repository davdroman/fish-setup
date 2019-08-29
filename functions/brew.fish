function bump_version
	# Bump version
	set bump_version $argv
	set cli_path Sources/CLI/CommandLineTool.swift
	sed -i '' "s/static let version = .*/static let version = \"$bump_version\"/g" $cli_path

	# Commit and push
	git add $cli_path
	git commit -m "Bump version number ($bump_version)"
	git tag $bump_version
	git push origin HEAD --tags
end

function update_formula
	# Bump version number and revision commit
	set folder_name (basename "$PWD" | tr '[:upper:]' '[:lower:]')
	set tap_path ../tap
	set recipe_path $tap_path/Formula/$folder_name.rb
	set tag_name (git describe --tags (git rev-list --tags --max-count=1))
	set tag_commit (git rev-list -n 1 $tag_name)
	set checksum (curl -sL https://github.com/davdroman/Badonde/archive/$tag_name.tar.gz | shasum -a 256 | cut -d ' ' -f1)

	# sed -i '' "s/tag => .*/tag => \"$tag_name\", :revision => \"$tag_commit\"/g" $recipe_path
	sed -i '' "s/version .*/version \"$tag_name\"/g" $recipe_path
	sed -i '' "s/sha256 .*/sha256 \"$checksum\"/g" $recipe_path

	# Commit and push changes
	cd $tap_path
	git add .
	git commit -m "Bump version number ($tag_name)"
	git push origin HEAD
	cd -
end
