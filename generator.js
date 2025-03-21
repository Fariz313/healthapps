const fs = require('fs');

// Fungsi untuk menghitung BB, TB, IMT, SD berdasarkan usia
const generateReferenceData = () => {
  let referenceData = [];
  let m3sd=2.1
  let m2sd=2.5
  let m1sd=3.3  
  let sd  
  let p1sd  
  let p2sd  
  let p3sd  

  // Loop untuk usia 0 bulan sampai 228 bulan (19 tahun 0 bulan)
  for (let age = 0; age <= 228; age++) {
    // Simulasi data rata-rata BB, TB, dan IMT (Anda harus mengganti dengan data yang tepat sesuai Permenkes)
    const bbMean = (3 + (age / 24)) + Math.random() * 1; // Rata-rata BB (kg)
    const bbSD = 0.5 + Math.random() * 0.3; // Deviasi standar BB (kg)
    const tbMean = (50 + (age / 4)) + Math.random() * 3; // Rata-rata TB (cm)
    const tbSD = 2 + Math.random() * 1; // Deviasi standar TB (cm)
    const imtMean = (bbMean / (tbMean / 100) ** 2); // Menghitung IMT berdasarkan BB dan TB
    const imtSD = 1 + Math.random() * 0.5; // Deviasi standar IMT
    
    // Menambahkan data referensi untuk usia tertentu
    referenceData[age] = {
      bbMean: parseFloat(bbMean.toFixed(2)),
      bbSD: parseFloat(bbSD.toFixed(2)),
      tbMean: parseFloat(tbMean.toFixed(2)),
      tbSD: parseFloat(tbSD.toFixed(2)),
      imtMean: parseFloat(imtMean.toFixed(2)),
      imtSD: parseFloat(imtSD.toFixed(2))
    };
  }

  return referenceData;
};

// Menghasilkan referenceData
const referenceData = generateReferenceData();

// Menyimpan ke file JSON
fs.writeFile('referenceData.json', JSON.stringify(referenceData, null, 2), (err) => {
  if (err) {
    console.error('Error writing file', err);
  } else {
    console.log('File referenceData.json has been generated successfully!');
  }
});
