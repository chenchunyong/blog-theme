echo "start generator."
hexo generate
echo "copy cname."
cp -f CNAME ./.deploy_git/
echo "end generator."
