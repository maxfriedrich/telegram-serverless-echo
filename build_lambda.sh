set -ex

poetry build --format wheel
poetry run pip install --upgrade --only-binary :all: --platform manylinux2014_x86_64 --target package dist/*.whl
pushd package
find . -exec touch -t 202201010000.00 {} \; 
zip -X --no-dir-entries --recurse-paths --exclude "*.pyc" -r ../lambda.zip .
popd
