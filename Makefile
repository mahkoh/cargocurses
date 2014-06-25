# Sources
LIB_SRC = src/ncurses.rs
LIB_DEPS = $(shell head -n1 target/.ncurses.deps 2> /dev/null)
EXAMPLES_SRC = $(wildcard src/bin/*.rs)

# Objects
LIB = target/$(shell rustc --crate-file-name ${LIB_SRC})
EXAMPLES_BIN = $(EXAMPLES_SRC:src/bin/%.rs=target/%)

# CFG Directive Options
CFG_OPT ?=

all: ${LIB} ${EXAMPLES_BIN}

lib: ${LIB}

link-ncursesw: CFG_OPT = --cfg ncursesw
link-ncursesw: all

${LIB}: ${LIB_DEPS}
	@mkdir -p target
	rustc ${CFG_OPT} --out-dir target ${LIB_SRC}
	@rustc --no-trans --dep-info target/.ncurses.deps ${LIB_SRC}
	@sed -i 's/.*: //' target/.ncurses.deps

${EXAMPLES_BIN}: target/%: src/bin/%.rs ${LIB}
	rustc --out-dir target -L target $<

clean:
	rm -rf target

.PHONY: all clean link-ncursesw
