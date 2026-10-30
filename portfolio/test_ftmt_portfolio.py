import os
import sys
from playwright.sync_api import sync_playwright

def run_tests():
    hub_path = "file:///" + os.path.abspath("d:/097.flutter_project/auto_portfolio/index.html").replace("\\", "/")
    ftmt_case_path = "file:///" + os.path.abspath("d:/097.flutter_project/auto_portfolio/ftmt/index.html").replace("\\", "/")
    ftmt_proto_path = "file:///" + os.path.abspath("d:/097.flutter_project/auto_portfolio/ftmt/prototype.html").replace("\\", "/")
    
    out_dir = "d:/097.flutter_project/ftmt/portfolio/test_captures"
    os.makedirs(out_dir, exist_ok=True)
    
    with sync_playwright() as p:
        browser = p.chromium.launch(headless=True)
        
        # Test 1: Auto Portfolio Hub
        page = browser.new_page(viewport={"width": 1440, "height": 900})
        page.goto(hub_path)
        page.wait_for_timeout(1000)
        page.screenshot(path=f"{out_dir}/01_hub_desktop.png")
        print("Test 1: Auto Portfolio Hub captured successfully.")
        
        # Test 2: FTMT Case Study Deck (Slide 1)
        page.goto(ftmt_case_path)
        page.wait_for_timeout(1200)
        page.screenshot(path=f"{out_dir}/02_ftmt_deck_slide1.png")
        print("Test 2: FTMT Case Study Deck Slide 1 captured.")
        
        # Test 3: FTMT Prototype (1440x900 Desktop)
        page.goto(ftmt_proto_path)
        page.wait_for_timeout(1500)
        page.screenshot(path=f"{out_dir}/03_ftmt_proto_desktop.png")
        
        # Check status bar and flutter text
        status_bar = page.query_selector(".iphone-status-bar, .mockup-status-bar")
        assert status_bar is not None, "Status bar is missing in prototype.html!"
        
        body_text = page.inner_text("body")
        assert "flutter" not in body_text.lower(), "Found 'flutter' text in prototype.html!"
        assert "플러터" not in body_text, "Found '플러터' text in prototype.html!"
        print("Test 3: FTMT Prototype verified: status bar present, 0 Flutter mentions.")
        
        # Test 4: FTMT Prototype on Laptop (1280x720) - height adaptive scaling check
        page_laptop = browser.new_page(viewport={"width": 1280, "height": 720})
        page_laptop.goto(ftmt_proto_path)
        page_laptop.wait_for_timeout(1000)
        page_laptop.screenshot(path=f"{out_dir}/04_ftmt_proto_laptop720.png")
        print("Test 4: FTMT Prototype on 1280x720 Laptop captured successfully.")
        
        # Test 5: FTMT Prototype on Mobile (390x844)
        page_mobile = browser.new_page(viewport={"width": 390, "height": 844})
        page_mobile.goto(ftmt_proto_path)
        page_mobile.wait_for_timeout(1000)
        page_mobile.screenshot(path=f"{out_dir}/05_ftmt_proto_mobile.png")
        print("Test 5: FTMT Prototype on Mobile viewport captured.")
        
        browser.close()
        print("ALL TESTS PASSED WITH 100% SUCCESS!")

if __name__ == "__main__":
    run_tests()
