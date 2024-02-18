clean:
	rm -rf pi.img

all: pi.img

pi.img: $(find . -type f -name '*.nix')
	nix build '.#images.pi'
	zstd --decompress --force -o pi.img ./result/sd-image/*.zst
	fdisk pi.img -l
