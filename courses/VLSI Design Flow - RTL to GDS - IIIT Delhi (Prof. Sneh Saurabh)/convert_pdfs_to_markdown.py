import pymupdf4llm
import os
from pathlib import Path

def convert_pdfs_to_markdown():
    """
    Convert all PDF lecture files to markdown format using pymupdf4llm
    """
    # Get the current directory where the script is located
    script_dir = Path(__file__).parent
    
    # Create output directory for markdown files
    output_dir = script_dir / "markdown_notes"
    output_dir.mkdir(exist_ok=True)
    
    # Get all PDF files that match the lecture pattern
    pdf_files = sorted([f for f in script_dir.glob("Lec*.pdf")])
    
    print(f"Found {len(pdf_files)} lecture PDF files to convert")
    print(f"Output directory: {output_dir}")
    print("-" * 60)
    
    # Convert each PDF to markdown
    for pdf_file in pdf_files:
        try:
            print(f"Processing: {pdf_file.name}...")
            
            # Convert PDF to markdown using pymupdf4llm
            md_text = pymupdf4llm.to_markdown(str(pdf_file))
            
            # Create output filename (e.g., Lec01.pdf -> Lec01.md)
            output_file = output_dir / f"{pdf_file.stem}.md"
            
            # Write markdown content to file
            with open(output_file, 'w', encoding='utf-8') as f:
                f.write(md_text)
            
            print(f"✓ Successfully converted to: {output_file.name}")
            
        except Exception as e:
            print(f"✗ Error processing {pdf_file.name}: {str(e)}")
    
    print("-" * 60)
    print(f"Conversion complete! Check the '{output_dir.name}' folder for markdown files.")

if __name__ == "__main__":
    convert_pdfs_to_markdown()
