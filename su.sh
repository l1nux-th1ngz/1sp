#!/bin/bash

mv *.sh ~/ 2>/dev/null
mv bookworm-scripts ~/ 2>/dev/null

cd ~

chmod +x *.sh

rm -rf 1sp

echo "Operations completed successfully."
