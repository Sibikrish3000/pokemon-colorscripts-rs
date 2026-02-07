use clap::Parser;
use rand::prelude::*;
use rust_embed::RustEmbed;
use serde::Deserialize;
use std::process;

// Embed the assets into the binary at compile time
#[derive(RustEmbed)]
#[folder = "colorscripts/"]
struct Colorscripts;

#[derive(RustEmbed)]
#[folder = "data/"]
struct Data;

#[derive(Deserialize, Debug, Clone)]
struct Pokemon {
    name: String,
    #[serde(rename = "forms")]
    _forms: Vec<String>,
}

#[derive(Parser, Debug)]
#[command(author, version, about = "Fast Pokemon Colorscripts in Rust")]
struct Args {
    #[arg(short, long)]
    list: bool,

    #[arg(short, long)]
    name: Option<String>,

    #[arg(short, long)]
    form: Option<String>,

    #[arg(long, default_value_t = true, action = clap::ArgAction::SetFalse)]
    no_title: bool,

    #[arg(short, long)]
    shiny: bool,

    #[arg(short, long)]
    big: bool,

    #[arg(short, long, default_missing_value = "1-8")]
    random: Option<Option<String>>,
}

const SHINY_RATE: f64 = 1.0 / 128.0;

fn get_pokemon_data() -> Vec<Pokemon> {
    let file = Data::get("pokemon.json").expect("Failed to find pokemon.json");
    serde_json::from_slice(&file.data).expect("Failed to parse JSON")
}

fn print_pokemon(name: &str, is_big: bool, is_shiny: bool, show_title: bool) {
    let size = if is_big { "large" } else { "small" };
    let color = if is_shiny { "shiny" } else { "regular" };
    let path = format!("{}/{}/{}", size, color, name);

    if show_title {
        println!("{}", if is_shiny { format!("{} (shiny)", name) } else { name.to_string() });
    }

    if let Some(file) = Colorscripts::get(&path) {
        println!("{}", std::str::from_utf8(&file.data).unwrap());
    } else {
        eprintln!("Error: Asset not found at {}", path);
    }
}

fn main() {
    let args = Args::parse();
    let pokemon_list = get_pokemon_data();

    if args.list {
        for p in pokemon_list { println!("{}", p.name); }
        return;
    }

    if let Some(name) = args.name {
        let shiny = args.shiny || thread_rng().gen_bool(SHINY_RATE);
        let mut final_name = name.clone();

        if let Some(f) = args.form {
            final_name = format!("{}-{}", name, f);
        }

        print_pokemon(&final_name, args.big, shiny, args.no_title);
    } else if let Some(_) = args.random {
        let mut rng = thread_rng();
        let random_p = pokemon_list.choose(&mut rng).unwrap();
        let shiny = args.shiny || rng.gen_bool(SHINY_RATE);

        print_pokemon(&random_p.name, args.big, shiny, args.no_title);
    } else {
        process::exit(0);
    }
}
