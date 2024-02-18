clean:
	rm -rf pi.img

all: pi.img

pi.img: $(find . -type f -name '*.nix')
	nix build '.#images.pi'
	zstd --decompress --force -o pi.img ./result/sd-image/*.zst
	fdisk pi.img -l

deploy:
	-git commit -am "."
	-git push www
	ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.2.15 -- nixos-rebuild switch --flake 'git+https://www.lan.heinrichhartmann.net/2024-02-18-nixos-rpi4-flake.git?rev=$(SHA)#pi'
	#-git push HH
	# ssh -o "UserKnownHostsFile=/dev/null" -o "StrictHostKeyChecking=no" root@192.168.2.15 -- nixos-rebuild switch --flake "github:HeinrichHartmann/2024-02-18-nixos-rpi4-flake?rev=$$(git rev-parse HEAD)#pi"
