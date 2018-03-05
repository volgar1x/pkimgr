# Pkimgr Installation

First of, check that you have a similar environment as me :

```
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Ubuntu
Description:	Ubuntu 16.04.4 LTS
Release:	16.04
Codename:	xenial
```

Then install these packages :

```
sudo apt update
sudo apt install -y git ruby postgresql nodejs nginx build-essential ruby-dev zlib1g-dev dh-autoreconf libpq-dev
```

Make sure you installed a ruby that is recent enough (2.3+) :

```
$ ruby -v
ruby 2.3.1p112 (2016-04-26) [x86_64-linux-gnu]
```

Then install `bundler` that we'll use to install Pkimgr's gems :

```
$ sudo gem install bundler
Fetching: bundler-1.16.1.gem (100%)
Successfully installed bundler-1.16.1
Parsing documentation for bundler-1.16.1
Installing ri documentation for bundler-1.16.1
Done installing documentation for bundler after 4 seconds
1 gem installed
```

Get Pkimgr's sources :

```
$ sudo git clone https://github.com/Blackrush/pkimgr /var/www/pkimgr
$ sudo chown -R www-data. /var/www/pkimgr
$ cd /var/www/pkimgr
```

And install the project's gems :

```
$ sudo bundle install --system
Bundle complete! 17 Gemfile dependencies, 69 gems now installed.
Use `bundle info [gemname]` to see where a bundled gem is installed.
```

Then create a database :

```
$ sudo systemctl start postgresql
$ sudo -u postgres psql -c "alter user postgres with password 'postgres';"
$ sudo -u postgres createdb pkimgr_prod
```

Then create a environment file :

```
$ sudo tee .env <<EOF
RAILS_ENV=production
SECRET_KEY_BASE=`xxd -c32 -l32 -ps /dev/urandom`
DATABASE_URL=postgresql://postgres:postgres@localhost/pkimgr_prod
EOF

$ export `cat .env`
```

Now you can install Pkimgr :

```
$ sudo -E rails assets:precompile
$ sudo -E rails db:migrate
$ sudo -E rails db:seed
```

Now install Nginx :

```
$ sudo rm /etc/nginx/sites-enabled/default
$ sudo tee /etc/nginx/sites-enabled/pkimgr <<EOF
upstream pkimgr {
	server unix:///var/www/pkimgr/pkimgr.sock;
}

server {
	listen 80;
	server_name _;

	location / {
		root              /var/www/pkimgr/public;
		try_files         \$uri @app;
		gzip_static       on;
		expires           max;
		add_header        Cache-Control public;
	}

	location @app {
		proxy_pass        http://pkimgr;
		proxy_set_header  X-Real-IP  \$remote_addr;
		proxy_set_header  X-Forwarded-For \$proxy_add_x_forwarded_for;
		proxy_set_header  X-Forwarded-Proto http;
		proxy_set_header  Host \$http_host;
		proxy_redirect    off;
		proxy_next_upstream error timeout invalid_header http_502;
	}
}
EOF
```

Now install project's SystemD configuration file :

```
$ sudo tee /etc/systemd/system/pkimgr.service <<EOF
[Unit]
Description=Pkimgr
After=network.target

[Service]
Type=simple
User=www-data
Group=www-data
WorkingDirectory=/var/www/pkimgr
EnvironmentFile=/var/www/pkimgr/.env
ExecStart=/usr/local/bin/puma -e production -b unix://pkimgr.sock
Restart=always

[Install]
WantedBy=multi-user.target
EOF

$ sudo systemctl daemon-reload
$ for s in nginx postgresql pkimgr; do
    sudo systemctl enable "$s"
    sudo systemctl start "$s"
  done
```

## Good job!

You can now test that your installation is effective :

```
curl -v http://localhost/
```

