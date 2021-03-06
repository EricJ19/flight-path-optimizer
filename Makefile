# Makefile modified from lab_intro's Makefile
EXENAME = flightsOpt
TEST = test
OBJS = main.o graph.o flightsVizualizer.o PNG.o HSLAPixel.o lodepng.o 
TESTOBJS = catchmain.o bfsTests.o DijkstraTests.o graphTests.o vizualizerTests.o

CXX = clang++
CXXFLAGS = $(CS225) -std=c++1y -stdlib=libc++ -c -g -O0 -Wall -Wextra -pedantic
LD = clang++
LDFLAGS = -std=c++1y -stdlib=libc++ -lc++abi -lm

# Custom Clang version enforcement logic:
ccred=$(shell echo -e "\033[0;31m")
ccyellow=$(shell echo -e "\033[0;33m")
ccend=$(shell echo -e "\033[0m")

IS_EWS=$(shell hostname | grep "ews.illinois.edu") 
IS_CORRECT_CLANG=$(shell clang -v 2>&1 | grep "version 6")
ifneq ($(strip $(IS_EWS)),)
ifeq ($(strip $(IS_CORRECT_CLANG)),)
CLANG_VERSION_MSG = $(error $(ccred) On EWS, please run 'module load llvm/6.0.1' first when running CS225 assignments. $(ccend))
endif
else
ifneq ($(strip $(SKIP_EWS_CHECK)),True)
CLANG_VERSION_MSG = $(warning $(ccyellow) Looks like you are not on EWS. Be sure to test on EWS before the deadline. $(ccend))
endif
endif

.PHONY: all test clean output_msg

all : $(EXENAME)

output_msg: ; $(CLANG_VERSION_MSG)

$(EXENAME) : output_msg $(OBJS)
	$(LD) $(OBJS) $(LDFLAGS) -o $(EXENAME)

main.o : main.cpp graph.h flightsVizualizer.h
	$(CXX) $(CXXFLAGS) main.cpp

graph.o : graph.cpp
	$(CXX) $(CXXFLAGS) graph.cpp

flightsVizualizer.o : flightsVizualizer.cpp
	$(CXX) $(CXXFLAGS) flightsVizualizer.cpp

lodepng.o : cs225/lodepng/lodepng.cpp cs225/lodepng/lodepng.h
	$(CXX) $(CXXFLAGS) cs225/lodepng/lodepng.cpp
	
PNG.o : cs225/PNG.cpp cs225/PNG.h cs225/HSLAPixel.h cs225/lodepng/lodepng.h
	$(CXX) $(CXXFLAGS) cs225/PNG.cpp

HSLAPixel.o : cs225/HSLAPixel.cpp cs225/HSLAPixel.h
	$(CXX) $(CXXFLAGS) cs225/HSLAPixel.cpp


# Tests
test : output_msg catchmain.o bfsTests.o DijkstraTests.o graphTests.o vizualizerTests.o PNG.o HSLAPixel.o lodepng.o graph.cpp flightsVizualizer.cpp
	$(LD) catchmain.o bfsTests.o DijkstraTests.o graphTests.o vizualizerTests.o PNG.o HSLAPixel.o lodepng.o graph.cpp flightsVizualizer.cpp $(LDFLAGS) -o $(TEST)
	
catchmain.o : cs225/catch/catchmain.cpp cs225/catch/catch.hpp 
	$(CXX) $(CXXFLAGS) cs225/catch/catchmain.cpp

bfsTests.o :tests/bfsTests.cpp
	$(CXX) $(CXXFLAGS) tests/bfsTests.cpp

DijkstraTests.o : tests/DijkstraTests.cpp
	$(CXX) $(CXXFLAGS) tests/DijkstraTests.cpp

graphTests.o : tests/graphTests.cpp
	$(CXX) $(CXXFLAGS) tests/graphTests.cpp

vizualizerTests.o : tests/vizualizerTests.cpp
	$(CXX) $(CXXFLAGS) tests/vizualizerTests.cpp

clean :
	-rm -f *.o $(EXENAME) $(TEST)
