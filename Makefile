# usage: make new content name=post-name
add-content:
	hugo new content posts/$(name).md

build:
	hugo build

server:
	hugo server