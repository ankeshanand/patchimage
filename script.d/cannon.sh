#!/bin/bash

WORKDIR=nsmb.d
DOL=${WORKDIR}/sys/main.dol
RIIVOLUTION_ZIP="Cannon_Super_Mario_Bros._Wii_v1.1.zip"
RIIVOLUTION_DIR="Cannon_Super_Mario_Bros._Wii_v1.1"
GAMENAME="Cannon Super Mario Bros."
XML_SOURCE="${RIIVOLUTION_DIR}"/SumSun/
XML_FILE="${RIIVOLUTION_DIR}"/riivolution/Cannon
GAME_TYPE=RIIVOLUTION
BANNER_LOCATION=${WORKDIR}/files/opening.bnr

show_notes () {

echo -e \
"************************************************
${GAMENAME}

Newer: Summer Sun is a short game with a hot theme, originally released
in Summer 2012. It features 23 new levels and some fresh music!

Source:			http://www.newerteam.com/specials.html
Base Image:		New Super Mario Bros. Wii (SMN?01)
Supported Versions:	EURv1, EURv2, USAv1, USAv2, JPNv1
************************************************"

}

check_input_image_special () {

	if [[ ! ${IMAGE} ]]; then
		if test -f SMN?01.wbfs; then
			IMAGE=SMN?01.wbfs
		elif test -f SMN?01.iso; then
			IMAGE=SMN?01.iso
		else
			echo -e "please specify image to use with --iso=<path>"
			exit 1
		fi
	fi

}

detect_game_version () {


	if [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232911 ]]; then
		VERSION=EURv1
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_152101 ]]; then
		VERSION=EURv2
		REG_LETTER=P
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_232303 ]]; then
		VERSION=USAv1
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2010-01-05_143554 ]]; then
		VERSION=USAv2
		REG_LETTER=E
	elif [[ -f ${WORKDIR}/files/COPYDATE_LAST_2009-10-03_231655 ]]; then
		VERSION=JPNv1
		REG_LETTER=J
	elif [[ ! ${VERSION} ]]; then
		echo -e "please specify your games version using --version={EURv1,EURv2,USAv1,USAv2,JPNv1}"
		exit 1
	fi

	GAMEID=SMN${REG_LETTER}04
	CUSTOM_BANNER=http://dl.dropboxusercontent.com/u/101209384/${GAMEID}.bnr

}

place_files () {

	NEW_DIRS=( ${WORKDIR}/files/NewerRes )
	for dir in ${NEW_DIRS[@]}; do
		mkdir -p ${dir}
	done

	case ${VERSION} in
		EUR* )
			LANGDIRS=( EngEU FraEU GerEU ItaEU SpaEU NedEU )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* ${WORKDIR}/files/EU/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningP/* ${WORKDIR}/files/EU/Layout/openingTitle/
		;;

		USAv* )
			LANGDIRS=( FraUS EngUS SpaUS )
			for dir in ${LANGDIRS[@]}; do
				cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* ${WORKDIR}/files/US/${dir}/
			done
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningE/* ${WORKDIR}/files/US/Layout/openingTitle/
		;;

		JPNv1 )
			cp -r "${RIIVOLUTION_DIR}"/Cannon/MessageEN/* ${WORKDIR}/files/JP/
			cp "${RIIVOLUTION_DIR}"/Cannon/OpeningJ/* ${WORKDIR}/files/JP/Layout/openingTitle/
		;;
	esac

	cp "${RIIVOLUTION_DIR}"/Cannon/Stage/Texture/* ${WORKDIR}/files/Stage/Texture/
	cp "${RIIVOLUTION_DIR}"/Cannon/NewerRes/* ${WORKDIR}/files/NewerRes/
	cp "${RIIVOLUTION_DIR}"/Cannon/Stage/*.arc ${WORKDIR}/files/Stage/
	cp "${RIIVOLUTION_DIR}"/Cannon/Env/* ${WORKDIR}/files/Env/
	cp "${RIIVOLUTION_DIR}"/Cannon/Sound/stream/* ${WORKDIR}/files/Sound/stream/
	cp "${RIIVOLUTION_DIR}"/Cannon/Sound/*.brsar ${WORKDIR}/files/Sound/
	cp "${RIIVOLUTION_DIR}"/Cannon/WorldMap/* ${WORKDIR}/files/WorldMap/
	cp "${RIIVOLUTION_DIR}"/Cannon/Object/* ${WORKDIR}/files/Object/
	cp "${RIIVOLUTION_DIR}"/Cannon/MovieDemo/* ${WORKDIR}/files/MovieDemo/
	cp -r "${RIIVOLUTION_DIR}"/Cannon/Layout/ ${WORKDIR}/files/

}

dolpatch () {

	cp "${XML_FILE}" "${XML_FILE}".new
	sed -e 's/80001800/803482C0/g' -i "${XML_FILE}".new
	XML_FILE="${XML_FILE}".new

	${WIT} dolpatch ${DOL} xml="${XML_FILE}" -s "${XML_SOURCE}" \
		"802F148C=53756D6D53756E#7769696D6A3264" \
		"802F118C=53756D6D53756E#7769696D6A3264" \
		"802F0F8C=53756D6D53756E#7769696D6A3264" \
		xml="patches/Cannon-Loader.xml" -q

	${WIT} dolpatch ${DOL} xml="patches/NSMBW_AP.xml" -q

}
