# Add homebrew binaries to the path.
export PATH=/usr/local/bin:$PATH

if [ -r ~/.bashrc ]; then
   source ~/.bashrc
fi
if [ -r ~/.bashenv ]; then
   source ~/.env
fi
