#!/usr/bin/ruby

versionPath = "/Contents/Versions/"
chromePluginPath = "/Google\ Chrome\ Framework.framework/Internet\ Plug-Ins/Flash\ Player\ Plugin\ for\ Chrome.plugin"

pluginPath = File.expand_path("~/Library/Internet\ Plug-Ins/Flash.plugin")

chromeLocation = IO.popen("mdfind \"kMDItemDisplayName=='Google Chrome'&&kMDItemKind==Application\"")

chromePath = chromeLocation.gets
print "Google Chrome.app found at: " + chromePath

chromeVersionPath = chromePath.delete("\n").delete("\r") + versionPath

if !File.exists? chromeVersionPath
	abort "Path to Chrome.app versions invalid!\n"
end

print "PROGRESS:20\n"

versions = Dir.entries(chromeVersionPath)

print "PROGRESS:40\n"

latest = ""

versions.each do |t|
	if latest < t
		latest = t
	end
end

if latest == ""
	abort "Could not determine latest version!\n"
end

print "PROGRESS:60\n"

print "Latest Chrome version found: " + latest + "\n"

if File.exists? pluginPath or File.symlink? pluginPath
	if File.symlink? pluginPath
		File.delete pluginPath
	else
		abort "Non-symlink file exisits at target path. Quitting...\n"
	end
end

print "PROGRESS:80\n"

originalPath = chromeVersionPath + latest + chromePluginPath

File.symlink originalPath, pluginPath

print "Successfully linked Flash.plugin!\n"
print "PROGRESS:100\n"