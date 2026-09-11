# composing.studio

This is the code for [composing.studio](https://composing.studio/), a web
application that aims to make music composition collaborative and accessible to
everyone.

<p align="center">
<a href="https://composing.studio/">
<img src="https://i.imgur.com/6L56aKA.png" width="800"><br>
<strong>composing.studio</strong>
</a>
</p>

## Rationale

Right now it’s possible to write music in a textual format called ABC, which
works for transcribing simple songs + guitar chords, as well as some other
pieces like chorales and folk music. It has some limitations, but not too many
(someone has encoded a Beethoven symphony in ABC before!).

Here’s an example of an interactive editor built with ABC:
https://editor.drawthedots.com/. The editor is not super user-friendly, but it
showcases the utility and interest in this space.

We provide a friendly and intuitive web-based interface for editing ABC music
notation, with syntax highlighting, live preview, audio playback, and real-time
collaboration. Anyone can create a new collaborative session by entering our
website, and they can share the link with fellow composers to work together and
come up with new ideas.

## Getting Started

This application is built using a backend operational transformation control
server written in Rust, based on [Rustpad](https://github.com/ekzhang/rustpad),
as well as a frontend written in TypeScript using [React](https://reactjs.org/).

The backend server has support for transient collaborative editing sessions, and
the frontend offers a collaborative text editor with custom Monarch ABC syntax
highlighting, cursors, and live presence tracking. These parts of the
application are connected by WebSocket communication.

On the frontend, we use the [abcjs](https://www.abcjs.net/) library to
dynamically render sheet music from ABC notation and generate interactive
playback controls through web audio synthesis.

To run this application, you need to install Rust, `wasm-pack`, and Node.js.
Then, build the WebAssembly portion of the app:

```
wasm-pack build --target web cstudio-wasm
```

When that is complete, you can install dependencies for the frontend React
application:

```
npm install
```

Next, compile and run the backend web server:

```
cargo run
```

While the backend is running, open another shell and run the following command
to start the frontend portion.

```
npm run dev
```

This command will open a browser window to `http://localhost:3000`, with hot
reloading on changes.

## Deploying on Build

[Build](https://build.io/) is a Heroku-compatible PaaS, so this app deploys
straight from git with the `bld` CLI.

1. Create the app and add its git URL as a remote:

   ```
   bld apps:create composing-studio
   git remote add bld "$(bld apps:info -a composing-studio -j | jq -r '.git_url')"
   ```

2. Add the three buildpacks — **the order matters**, since each one sets up the
   toolchain the next depends on:

   ```
   bld buildpacks:add https://github.com/usiegl00/heroku-buildpack-rust --app composing-studio
   bld buildpacks:add https://github.com/weibeld/heroku-buildpack-run --app composing-studio
   bld buildpacks:add https://github.com/heroku/heroku-buildpack-nodejs --app composing-studio
   ```

3. Push to deploy:

   ```
   git push bld main
   ```

4. Once the build finishes, check the dyno and open the app:

   ```
   bld ps -a composing-studio
   bld apps:info -a composing-studio -j | jq -r '.web_url'
   ```

## Contributing

This project is still in a **very experimental** phase. We're exploring
different ways of allowing musicians to collaborate with each other in a global
community. If you're interested in adding features or helping fix bugs, please
reach out to us first by creating a GitHub issue!

We have continuous integration for this repository, which checks things like
code style (Prettier, Rustfmt) and successful build (Docker). The current state
of the `main` branch is continuously deployed to the production web server at
[composing.studio](https://composing.studio/).

<br>

<sup>
All code is licensed under the <a href="LICENSE">MIT license</a>.
</sup>
