<template>
    <div class="container mt-5">
      <h2 class="text-center">Form Data Pasien</h2>
      <form @submit.prevent="submitForm">
        <div class="form-group">
          <label for="tanggal">Tanggal</label>
          <input type="date" v-model="form.tanggal" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="asalDesa">Asal Desa/Lokasi Posyandu</label>
          <input type="text" v-model="form.asalDesa" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="namaAnak">Nama Anak</label>
          <input type="text" v-model="form.namaAnak" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="orangTua">Nama Orang Tua</label>
          <input type="text" v-model="form.orangTua" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="noHp">No. HP</label>
          <input type="tel" v-model="form.noHp" class="form-control" required />
        </div>
        <div class="form-group">
          <label>Gender</label>
          <select v-model="form.gender" class="form-control" required>
            <option value="Laki-laki">Laki-laki</option>
            <option value="Perempuan">Perempuan</option>
          </select>
        </div>
        <div class="form-group">
          <label for="usia">Usia (bulan)</label>
          <input type="number" v-model="form.usia" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="beratBadan">Berat Badan Anak (kg)</label>
          <input type="number" step="0.1" v-model="form.beratBadan" class="form-control" required />
        </div>
        <div class="form-group">
          <label for="tinggiBadan">Tinggi Badan Anak (cm)</label>
          <input type="number" v-model="form.tinggiBadan" class="form-control" required />
        </div>
        <button type="submit" class="btn btn-primary mt-3">Simpan Data</button>
      </form>
    </div>
  </template>
  
  <script>
  export default {
    data() {
      return {
        form: {
          tanggal: '',
          asalDesa: '',
          namaAnak: '',
          orangTua: '',
          noHp: '',
          gender: '',
          usia: '',
          beratBadan: '',
          tinggiBadan: '',
        }
      };
    },
    methods: {
      submitForm() {
        console.log("Data Pasien:", this.form);
        alert("Data berhasil disimpan!");
      }
    }
  };
  </script>
  
  <style scoped>
  .container {
    max-width: 600px;
    margin: auto;
    background: #f9f9f9;
    padding: 20px;
    border-radius: 10px;
  }
  </style>