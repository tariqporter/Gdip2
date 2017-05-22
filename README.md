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
npm run webpack
```

This will run webpack with the `-w` option (as specified in `package.json`), which will watch all included `.ahk` files for any change based upon the use of `#Include`, and automatically rebuild to the `dist` folder

The Gdip2 library uses [webpack ahk-loader](https://github.com/tariqporter/ahk-loader) to watch and build files

### To run continual tests on `Gdip2.ahk`

You just need to run

```bash
npm test
```

This will run `ahk-unit ./tests/tests.ahk`.
Any included file-change will cause a re-run of all tests
