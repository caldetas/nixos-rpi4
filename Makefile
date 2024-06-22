clean:
	rm -rf nixos.img

all: nixos.img

nixos.img: $(find . -type f -name '*.nix')
	nix build '.#images.nixos' --impure
	zstd --decompress --force -o nixos.img ./result/sd-image/*.zst
	fdisk nixos.img -l

deploy:
	-git commit -am "."
	#-git push www
	#ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.178.102 -- nixos-rebuild switch --flake "git+https://github.com/caldetas/nixos-rpi4.git?rev=$$(git rev-parse HEAD)#nixos"
	-git push HH
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.178.102 -- nixos-rebuild switch --flake "github:caldetas/nixos-rpi4?rev=$$(git rev-parse HEAD)#nixos"
