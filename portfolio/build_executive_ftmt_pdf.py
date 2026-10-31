import os
import fitz # PyMuPDF
from PIL import Image, ImageDraw, ImageFilter

def build_pdf():
    print("=== Building Enterprise FortuneMatch_Portfolio.pdf (1:1 Native Full-Scale Bleed-to-Edge) ===")
    
    slides_dir = r"d:\097.flutter_project\auto_portfolio\ftmt\behance_slides"
    
    target_pdfs = [
        r"d:\097.flutter_project\auto_portfolio\ftmt\FortuneMatch_Portfolio.pdf",
        r"d:\097.flutter_project\ftmt\portfolio\FortuneMatch_Portfolio.pdf"
    ]
    
    doc = fitz.open()
    proto_url = "https://koyotejw-ux.github.io/ftmt/portfolio/index.html"
    
    for i in range(1, 13):
        slide_path = os.path.join(slides_dir, f"slide_{i:02d}.png")
        if not os.path.exists(slide_path):
            raise FileNotFoundError(f"Slide not found: {slide_path}")
            
        page = doc.new_page(width=1920, height=1080)
        page.insert_image(fitz.Rect(0, 0, 1920, 1080), filename=slide_path)
        
        # Interactive hyperlinks mapped to exact 1920x1080 design coordinates
        if i == 10:
            # 6 Core Mockup Devices & Bottom Pipeline Chips
            for rx1, ry1, rx2, ry2 in [
                (130, 205, 340, 780), (420, 205, 630, 780), (710, 205, 920, 780),
                (1000, 205, 1210, 780), (1290, 205, 1500, 780), (1580, 205, 1790, 780),
                (300, 920, 500, 970), (560, 920, 770, 970), (830, 920, 1040, 970),
                (1100, 920, 1310, 970), (1370, 920, 1570, 970), (1630, 920, 1800, 970)
            ]:
                page.insert_link({'kind': fitz.LINK_URI, 'from': fitz.Rect(rx1, ry1, rx2, ry2), 'uri': proto_url})
                
        elif i == 12:
            # Master launcher, 4 steps & QR Code
            for rx1, ry1, rx2, ry2 in [
                (100, 205, 760, 850), (100, 865, 760, 980), (800, 196, 1820, 348),
                (800, 365, 1820, 440), (800, 450, 1820, 525), (800, 535, 1820, 610),
                (800, 620, 1820, 695), (800, 710, 1820, 980)
            ]:
                page.insert_link({'kind': fitz.LINK_URI, 'from': fitz.Rect(rx1, ry1, rx2, ry2), 'uri': proto_url})
                
        print(f"Page {i:02d} inserted 1:1 without margin/downscaling.")
        
    doc.set_metadata({
        'title': 'FortuneMatch Portfolio Deck',
        'author': 'Lead UX/UI Designer',
        'subject': 'FortuneMatch Case Study',
        'keywords': 'Flutter, Portfolio, UXUI',
        'creator': 'FortuneMatch Executive Generator',
        'producer': 'PyMuPDF'
    })
    
    # Save with temporary swapping to avoid file lock issues
    for pdf_out in target_pdfs:
        os.makedirs(os.path.dirname(pdf_out), exist_ok=True)
        temp_out = pdf_out + ".tmp"
        doc.save(temp_out, garbage=4, deflate=True)
        import shutil
        shutil.move(temp_out, pdf_out)
        print(f"Saved: {pdf_out} ({os.path.getsize(pdf_out):,} bytes)")
        
    doc.close()
    print("=== Complete Portfolio Framed PDF Generation Done! ===")

if __name__ == '__main__':
    build_pdf()
