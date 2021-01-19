
NC='\e[39m'
GN='\e[92m'
RD='\e[91m'


echo ""
echo "==============================="
echo " Looks for forms/inputs"
echo "==============================="
echo ""

read -p "List of URLs: " urls
read -p "Output: " out

cat $urls | while read line 
do
curl -si --max-time 2 $line|tac|tac|if grep -qiE '<([fF]orm|[iI]nput)>|([mM]ethod)="(...|....|.....|......)"|="([Ss]ubmit)"'; then 
echo "${GN}[+]${NC} $line ${GN}Form detected!${NC}"
echo "$line" >> $out
else
echo "${RD}[-]${NC} $line ${RD}No forms${NC}"
fi #&
done

