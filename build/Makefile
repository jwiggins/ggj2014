all: windows mac

src: ../heisengame.love/*.lua ../heisengame.love/maps/*
	rsync -ar --delete ../heisengame.love/ src/
	touch src

release/heisengame.love: src release
	cd src; zip -9 -q -r ../release/heisengame.love .

release:
	mkdir release

release/windows/heisengame.exe: release/heisengame.love
	rsync -ar --delete ../../love_dist/love-0.9.0-win32/ release/windows/
	cat release/windows/love.exe release/heisengame.love > release/windows/heisengame.exe
	rm release/windows/love.exe release/windows/changes.txt release/windows/readme.txt

.PHONY: windows
windows: release/windows/heisengame.exe

release/mac/heisengame.app: release/heisengame.love
	mkdir -p release/mac
	rsync -ar --delete ../../love_dist/love.app/ release/mac/heisengame.app/
	cp release/heisengame.love release/mac/heisengame.app/Contents/Resources/heisengame.love
	cp Info.plist release/mac/heisengame.app/Contents/Info.plist

.PHONY: mac
mac: release/mac/heisengame.app

.PHONY: clean
clean:
	rm -rf release/ src/