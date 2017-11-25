# adapted from https://gist.github.com/hjst/4f2f2c2ca9bd550e50c7f06cb17775b2

PLANTUML_JAR_URL = https://sourceforge.net/projects/plantuml/files/plantuml.jar/download
DIAGRAMS_SRC := $(wildcard **/*.plantuml)
DIAGRAMS_PNG := $(addsuffix .png, $(basename $(DIAGRAMS_SRC)))
DIAGRAMS_SVG := $(addsuffix .svg, $(basename $(DIAGRAMS_SRC)))

all: png svg

# build PNGs, probably what we want most of the time
png: plantuml.jar $(DIAGRAMS_PNG)

# SVG are nice-to-have but don't need to build by default
svg: plantuml.jar $(DIAGRAMS_SVG)

# clean up compiled files
clean:
	rm -f plantuml.jar $(DIAGRAMS_PNG) $(DIAGRAMS_SVG)

# If the JAR file isn't already present, download it
plantuml.jar:
	curl -sSfL $(PLANTUML_JAR_URL) -o plantuml.jar

# Each PNG output depends on its corresponding .plantuml file
**/%.png: **/%.plantuml 
	java -jar plantuml.jar -tpng $^

# Each SVG output depends on its corresponding .plantuml file
**/%.svg: **/%.plantuml 
	java -jar plantuml.jar -tsvg $^
