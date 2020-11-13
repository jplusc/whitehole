# whitehole
auto whitelisting for pi-hole
** note, this is obsolete, needs updated for pi-hole v5 -- only works with pi-hole v4 atm.


```
cd /opt/
sudo wget https://raw.githubusercontent.com/jplusc/whitehole/master/whitehole.sh
sudo chmod +x /opt/whitehole.sh
sudo /opt/whitehole.sh
```

```
sudo wget https://raw.githubusercontent.com/jplusc/whitehole/master/whitehole.sh -O /opt/whitehole.sh
```


```
cd /opt
sudo git clone https://github.com/jplusc/whitehole.git
chmod +x whitehole.sh
sudo ./whitehole.sh
```

```
sudo nano /etc/crontab
 00  4  *  * */7 root     /opt/whitehole.sh
 00  3 15  *  *  root     wget https://raw.githubusercontent.com/jplusc/whitehole/master/whitehole.sh -O /opt/whitehole.sh
```
