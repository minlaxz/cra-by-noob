### Too many node_modules with multiple create-react-app or yarn create react-app or npx create-react-app projects

TESTING ON MY MACHINE - ZSH, Ubunut 2004

ok this would be my personal issue cuz each **create-react-app** project takes **166.7MB** and **39957 files**

TL;DR

`curl -fsSL https://getcra.minlaxz.me | bash -s -- -i ` // to install cra-noob

`curl -fsSL https://getcra.minlaxz.me | bash -s -- -r ` // to remove cra-noob

OR just

`curl -fsSL https://getcra.minlaxz.me | bash -` // to install

and run `cra` or `cra -n <your_project_name>` and coffee break ☕

[cra.sh](cra.sh) will download just bootstrapped files and dirs of original **create-react-app** files

also will create _package.json_ with updated version of react-scripts used in `create-react-app` and projectName etc.

- **project_name/src/\***
- **project_name/build/\***
- **project_name/\*** some other files but _package.json_ (excluded)

---

### With docker-compose and kool

[kool](https://kool.dev) is a cli tool based on docker and docker-compose

so you will need

- docker
- docker-compose
- kool

just run `kool start` in porject folder

---

### With yarn workspaces

TODO for README

---

### Why?

### from create-react-app

I want to cut these

- git first commit with bootstrapped files
- auto installation of node_modules
- duplicated packages with yarn workspaces

I want these

- can use with yarn workspaces
- can still control the packages
- can run with docker container which is build with cra node_modules
- and exp with containers

---

As usual, you will need to run `yarn install` or just `yarn` in root of your project.

But you could use yarn workspaces to shrink multile duplicated node_modules by sharing them (as monorepos).

I used yarn workspaces and I wanted in each repo with their specific _yarn.lock_.

---

### How the hell this popular execution works ? with _subdomain.domain.tld_ | shell -- args

actual comand should be ...

`curl -fsSL https://raw.githubusercontent.com/minlaxz/cra-by-noob/main/cra.sh | sh`

and it is a devil for lazy ones and too many to memorize 🥴

Raw version of this [cra.sh](cra.sh) is redirected from cloudflare workers

CF workers route is linking with my domain name minlaxz.me

This way I can curl -L to this [cra.sh](cra.sh) from [cra.minlaxz.me](https://cra.minlaxz.me) domain then piped to `sh`

mind `-L` in `curl` when initial host return **3XX**, curl will redo the request with returned host

more about [curl -fsSL](https://explainshell.com/explain?cmd=curl+-fsSL)

If you're from **Myanmar** just like me, you will need `VPN` as _Myanmar Junta Min Aung Hlaing_ (son of bitch) is blocking the Cloudflare.

[IF YOU WANT TO KNOW SON OF BITCH IN MYANMR - Google Search](https://www.google.com/search?q=myanmar+junta&source=lmns&bih=981&biw=1874&hl=en&sa=X&ved=2ahUKEwig1cPZgJDyAhVKXCsKHda6CvkQ_AUoAHoECAEQAA)


---
---

Notes for me

- git co --orphan docs
- git rm -r --cached .
- nano index.md
- git ci -am "Message"
- git push origin docs
- git co main # for code
- git co docs # for github pages