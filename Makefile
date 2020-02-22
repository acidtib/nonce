build.development:
	crystal build src/nonce.cr

build.production:
	crystal build --warnings all --stats --progress --release -o nonce src/nonce.cr
	
run:
	crystal run src/nonce.cr