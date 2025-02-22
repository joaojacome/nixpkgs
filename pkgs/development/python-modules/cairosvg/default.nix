{ lib
, buildPythonPackage
, fetchPypi
, isPy3k
, cairocffi
, cssselect2
, defusedxml
, pillow
, tinycss2
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "CairoSVG";
  version = "2.6.0";
  disabled = !isPy3k;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-1eyT6QEBs7boKqJF0FRu6bAWz9oLY0RnUVmDDYU9XQQ=";
  };

  propagatedBuildInputs = [ cairocffi cssselect2 defusedxml pillow tinycss2 ];

  propagatedNativeBuildInputs = [ cairocffi ];

  checkInputs = [ pytestCheckHook ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" "" \
      --replace "pytest-flake8" "" \
      --replace "pytest-isort" "" \
      --replace "pytest-cov" "" \
      --replace "--flake8" "" \
      --replace "--isort" ""
  '';

  pytestFlagsArray = [
    "cairosvg/test_api.py"
  ];

  pythonImportsCheck = [ "cairosvg" ];

  meta = with lib; {
    homepage = "https://cairosvg.org";
    license = licenses.lgpl3Plus;
    description = "SVG converter based on Cairo";
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
