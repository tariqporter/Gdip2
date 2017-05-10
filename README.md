# Gdip2
GDI+ library for Autohotkey supporting Objects

### Take precompiled Gdip2 from the `dist` folder
###
###
### Alternatively if you wish to develop with Gdip2

Ensure you have [Node](https://nodejs.org) installed.
Change to your directory

```bash
cd c:\your\directory
```

Install npm dependencies

```bash
npm install
```

and then run webpack to build to `dist` folder

```bash
webpack -w
```

`-w` option will watch all included `.ahk` files for any change, and automatically rebuild to the `dist` folder

The Gdip2 library uses [webpack ahk-loader](https://github.com/tariqporter/ahk-loader) to watch and build files