pi.img: $(git ls-files)
	nix build '.#images.pi'
	zstd --decompress --force -o pi.img ./result/sd-image/*.zst
	fdisk pi.img -l
