#!/usr/bin/env node
// Bullet-proof FPS measurement for overlay
// Real frame timing with Puppeteer

const puppeteer = require('puppeteer');
const fs = require('fs');

async function measureFPS() {
    console.log('🔬 MEASURING OVERLAY FPS');
    console.log('=' .repeat(50));

    const browser = await puppeteer.launch({
        headless: false,
        args: ['--disable-web-security', '--disable-features=VizDisplayCompositor']
    });

    const page = await browser.newPage();
    await page.goto('http://localhost:5173');
    
    // Wait for page to load
    await page.waitForTimeout(3000);

    const fpsResults = [];
    const iterations = 60;

    for (let i = 0; i < iterations; i++) {
        const fps = await page.evaluate(() => {
            return new Promise(resolve => {
                let frameCount = 0;
                const startTime = performance.now();
                
                const countFrames = () => {
                    frameCount++;
                    if (performance.now() - startTime >= 1000) {
                        resolve(frameCount);
                        return;
                    }
                    requestAnimationFrame(countFrames);
                };
                
                requestAnimationFrame(countFrames);
            });
        });
        
        fpsResults.push(fps);
    }

    const stats = {
        meanFPS: fpsResults.reduce((a, b) => a + b, 0) / fpsResults.length,
        minFPS: Math.min(...fpsResults),
        maxFPS: Math.max(...fpsResults),
        p95FPS: fpsResults.sort((a, b) => a - b)[Math.floor(fpsResults.length * 0.95)],
        iterations: fpsResults.length
    };

    console.log(`Mean FPS: ${stats.meanFPS.toFixed(2)}`);
    console.log(`Min FPS: ${stats.minFPS}`);
    console.log(`Max FPS: ${stats.maxFPS}`);
    console.log(`95th percentile: ${stats.p95FPS}`);

    fs.writeFileSync('/workspace/results/fps.json', JSON.stringify(stats, null, 2));

    await browser.close();
}

measureFPS().catch(console.error);