<template>
  <div class="container mx-auto px-4 py-6">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailModalLabel">Detail Data Pasien</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <template v-if="(record)">
          <div v-if="(record.BP < 120 && record.BP2 < 80)" class="alert alert-success" role="alert">
            <b>Tekanan Darah Normal Pertahankan !</b>
          </div>
          <div v-else-if="record.BP < 140 && record.BP2 < 90" class="alert alert-warning" role="alert">
            <b>Pre Hipertensi</b>
            <p>Anjuran Perubahan Gaya Hidup</p>
            <ol>
              <li>
                Penurunan Berat Badan
                <br>
                Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
              </li>
              <li>
                Diet Tinggi serat dan rendah lemak (DASH)
              </li>
              <li>Pembatasan intake natrium <br>
                Kurangi 2,0 gr natrium atau 1 sendok teh garam per hari
              </li>
              <li>
                Aktifitas fisik aerobik
                <br>
                Aktifitas fisik aerobik yang teratur 20-30 menit dengan frekuensi 2-3 kali seminggu
              </li>
              <li>
                Pembatasan konsumsi alkohol
                <br>
                max 30ml bagi laki-laki
                <br>
                max 20ml bagi perempuan
              </li>
              <li>
                Pembatasan merokok
              </li>
            </ol>
          </div>
          <div v-else-if="record.BP < 160 && record.BP2 < 100" class="alert alert-warning" role="alert">
            <b>Pre Hipertensi</b>
            <p>Anjuran Perubahan Gaya Hidup</p>
            <ol>
              <li>
                Penurunan Berat Badan
                <br>
                Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
              </li>
              <li>
                Diet Tinggi serat dan rendah lemak (DASH)
              </li>
              <li>Pembatasan intake natrium <br>
                Kurangi 2,0 gr natrium atau 1 sendok teh garam per hari
              </li>
              <li>
                Aktifitas fisik aerobik
                <br>
                Aktifitas fisik aerobik yang teratur 20-30 menit dengan frekuensi 2-3 kali seminggu
              </li>
              <li>
                Pembatasan konsumsi alkohol
                <br>
                max 30ml bagi laki-laki
                <br>
                max 20ml bagi perempuan
              </li>
              <li>
                Pembatasan merokok
              </li>
            </ol>
            <p>Segera kunjungi fasilitas kesehatan jika 2 minggu pasca modifikasi gaya hidup target tekanan darah tidak
              tercapai</p>
          </div>
          <div v-else-if="record.BP < 160 && record.BP2 < 100" class="alert alert-warning" role="alert">
            <b>Pre Hipertensi grade 2</b>
            <p>Segera datangi fasilitas kesehatan untuk mendapat pengobatan dari dokter</p>
            <ol>
              <li>Dilakukan pengobatan & pengawasan oleh dokter</li>
            </ol>
            <p>Anjuran Perubahan Gaya Hidup</p>
            <ol>
              <li>
                Penurunan Berat Badan
                <br>
                Jaga berat badan ideal IMT: 18.5 - 22.9 kg/m2
              </li>
              <li>
                Diet Tinggi serat dan rendah lemak (DASH)
              </li>
            </ol>
          </div>
          <p><strong>Pasien:</strong> {{ record.name }}</p>
          <p><strong>Recorded By:</strong> {{ record.recorded_by }}</p>
          <p><strong>Tanggal:</strong> {{ formatDate(record.created_at) }}</p>

          <template v-for="field in allFields" :key="field.name">

            <div>
              <p> <strong>{{ field.label }} :</strong> {{ record[field.name] }} {{ field.unit }}
              </p>
            </div>
          </template>
        </template>
      </div>
      <div class="modal-footer">
        <div class="mt-6">
          <span class="font-semibold text-base mb-2">Bagikan atau Simpan QR</span> <br>
          <ClientOnly>
            <qrcode-vue :value="url" :size="150" />
          </ClientOnly>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useRoute } from 'vue-router'
import { useRuntimeConfig } from '#imports'
import QrcodeVue from 'qrcode.vue'
import axios from 'axios'
const route = useRoute()
const { public: config } = useRuntimeConfig()

const id = route.params.id
const url = ref(`${config.siteUrl}/ptm/${id}`)
console.log("TEST");
const data = await axios.get(`https://api.kaderpintar.id/api/ptm/${id}`)
console.log(data);
const record = data.data

const numericFields = [
  { name: 'weight', label: 'Berat', unit: 'Kg' },
  { name: 'height', label: 'Tinggi', unit: 'Cm' },
  { name: 'BP', label: 'Tekanan sistolik', unit: 'mmHg' },
  { name: 'BP2', label: 'Tekanan diastolik', unit: 'mmHg' },
  { name: 'GDS', label: 'GDS', unit: '' },
  { name: 'GDP', label: 'GDP', unit: '' }
]

function formatDate(dateString) {
  const date = new Date(dateString)
  return date.toLocaleString('id-ID', {
    timeZone: 'Asia/Jakarta',
    year: 'numeric',
    month: 'short',
    day: 'numeric',
    hour: '2-digit',
    minute: '2-digit'
  })
}
</script>