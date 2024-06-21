clean:
	rm -rf pi.img

all: pi.img

pi.img: $(find . -type f -name '*.nix')
	nix build '.#images.pi' --impure
	zstd --decompress --force -o pi.img ./result/sd-image/*.zst
	fdisk pi.img -l

deploy:
	-git commit -am "."
	#-git push www
	#ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.2.15 -- nixos-rebuild switch --flake "git+https://github.com/caldetas/nixos-rpi4.git?rev=$$(git rev-parse HEAD)#pi"
	-git push HH
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.2.15 -- nixos-rebuild switch --flake "github:caldetas/nixos-rpi4?rev=$$(git rev-parse HEAD)#pi"
