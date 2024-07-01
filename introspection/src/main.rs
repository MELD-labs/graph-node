use std::io;
use std::io::Read;

// use graph::prelude::Schema;
use graph::prelude::DeploymentHash;
use graph::schema::InputSchema;
use graph::prelude::s::Document;

fn run() -> Result<Document, String> {
    let mut raw_schema = String::new();
    io::stdin().read_to_string(&mut raw_schema).map_err(|_| "Cannot read input schema from stdin")?;
    let hash = DeploymentHash::new("").map_err(|_| "Cannot create empty deployment hash")?;
    let input_schema = InputSchema::parse_latest(raw_schema.as_str(), hash).map_err(|_| "Cannot parse input schema")?;
    let api_schema = input_schema.api_schema().map_err(|_| "Cannot generate api schema")?;
    Ok(api_schema.document().clone())
}

fn main() {
    match run() {
        Ok(schema) => println!("{schema}"),
        Err(err) => eprintln!("Error: {}", err),
    }
}
