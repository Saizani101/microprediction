echo "This script will run DefaultCrawler from a new virtual env"
echo "If it fails you might need to brew install python"
mkdir -p crawling_working_dir
cd crawling_working_dir
python3 -m venv crawling
source crawling/bin/activate
pip install --upgrade pip
pip install --upgrade wheel
pip install --upgrade git+https://github.com/microprediction/microprediction.git
 
echo "------ Installation complete ------"

WRITE_KEY_FILE = "WRITE_KEY.txt"
if [ -f "$WRITE_KEY_FILE" ]
then
   echo "Found "$WRITE_KEY_FILE
else
   echo "Next, burning a write_key which will be your identity. This may take a long time. Go get lunch."
   echo 
   sleep 3
   python3 -c "from microprediction import new_key;WRITE_KEY = new_key(difficulty=11);print(WRITE_KEY)" > "WRITE_KEY.txt"
fi


sleep 3 
write_key=$(cat "WRITE_KEY.txt")
echo $write_key

START=`date +%s` 
while [ $(( $(date +%s) - 300000 )) -lt $START ]; do
    write_key=$(cat "WRITE_KEY.txt")
    pip install --upgrade microprediction.git
    python3 -c "from microprediction import DefaultCrawler;crawler = DefaultCrawler(write_key='"$write_key"'); crawler.run()"
    echo "I guess something went wrong, or this is a scheduled update time. Not to worry either way. We shall resume in 60 seconds". 
    sleep 60
done


