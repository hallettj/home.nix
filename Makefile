FLAKE_PARTS_MODULES := $(shell find modules/ -name '[^_]*.nix')
ALL_FILES := $(shell git ls-files)

.PHONY: all
all: build

flake.nix: $(FLAKE_PARTS_MODULES)
	nix run .#write-flake

result: $(ALL_FILES) # includes flake.nix because it is version controlled
	nh os build . -- --show-trace

.PHONY: build
build: result

.PHONY: boot
boot: flake.nix
	nh os boot .

.PHONY: switch
switch: flake.nix
	nh os switch .
