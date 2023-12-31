{ stdenv, lib, fetchFromGitHub, kernel }:

stdenv.mkDerivation {
	pname = "hid-tmff2";
	version = "unstable-2023-09-23";

	src = fetchFromGitHub {
		owner = "Kimplul";
		repo = "hid-tmff2";
		rev = "b2872a893afd0f9cd0bfd4644348f3b8645edbed";
		hash = "sha256-7AlBxFUqw0nFl9f03WWDhUQsd1RCdtvcUeVWfcO9J8Q=";
		fetchSubmodules = true;
	};

	nativeBuildInputs = kernel.moduleBuildDependencies; 

	makeFlags = kernel.makeFlags ++ [
		"KDIR=${kernel.dev}/lib/modules/${kernel.modDirVersion}/build"
	];

	installFlags = [
		"INSTALL_MOD_PATH=${placeholder "out"}"
	];
  
	postPatch = "sed -i '/depmod -A/d' Makefile";

	meta = with lib; {
		description = "A linux kernel module for Thrustmaster T300RS and T248";
		homepage = "https://github.com/Kimplul/hid-tmff2";
		license = licenses.gpl2Plus;
		maintainers = [ maintainers.rayslash ];
		platforms = platforms.linux;
	};
}