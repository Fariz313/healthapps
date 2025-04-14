<template>
  <div class="container mx-auto px-4 py-6">
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailModalLabel">Detail Data Pasien</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <template v-if="selectedRecord">
          <div v-if="selectedRecord.totalPoints < 6" class="alert alert-success" role="alert">
            <b>Anda termasuk kedalam kehamilan Resiko rendah</b>
            <p>Kehamilan resiko rendah adalah kehamilan fisiologi tanpa masalah atau faktor resiko,
              dan kemungkinan besar untuk dilakukan persalinan normal.</p>
          </div>
          <div v-else-if="selectedRecord.totalPoints < 12" class="alert alert-warning" role="alert">
            <b>Anda termasuk kedalam kehamilan Resiko Tinggi</b>
            <p>Kehamilan resiko tinggi adalah kehamilan dengan satu atau lebih faktor resiko, yang
              berasal dari ibu maupun janin. resiko tergolong gawat tapi tidak darurat.
              Pertolongan persalinan dapat dilakukan di bidan atau dokter di puskesmas, polindes,
              atau langsung di rujuk ke rumah sakit</p>
          </div>
          <div v-else class="alert alert-danger" role="alert">
            <b>Anda termasuk kedalam kehamilan Sangat Tinggi</b>
            <p>Ibu hamil membutuhkan pertiolongan di rumah sakit oleh dokter spesialis. Hal ini
              dikarenakan kehamilan dengan resiko sangat tinggi beresiko pendarahan sebelum
              persalinan, termasuk kondisi gawat darurat bagi keselamatan ibu dan bayi, sehingga
              membutuhkan rujukan ke rumah sakit</p>
          </div>
          <p><strong>Pasien:</strong> {{ selectedRecord.name }}</p>
          <p><strong>Recorded By:</strong> {{ selectedRecord.recorded_by }}</p>
          <p><strong>Tanggal:</strong> {{ formatDate(selectedRecord.created_at) }}</p>

          <template v-for="field in allFields" :key="field.name">
            <div v-if="!['weight', 'height', 'age_at_pregnancy'].includes(field.name)">
              <p class="text-danger" v-if="(selectedRecord[field.name] == 1)"><strong class="text-dark">{{ field.label
                  }}:</strong> {{
                    formatValue((selectedRecord[field.name] == 1)) }}</p>
              <p class="text-success" v-if="(selectedRecord[field.name] != 1)"><strong class="text-dark">{{ field.label
                  }}:</strong> {{
                    formatValue((selectedRecord[field.name] == 1)) }}</p>
            </div>
            <div v-else>
              <p> <strong>{{ field.label }} :</strong> {{ selectedRecord[field.name] }} {{ field.unit }}
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
import { ref } from 'vue';
import QrcodeVue from 'qrcode.vue'
import axios from 'axios';
const route = useRoute()
const { public: config } = useRuntimeConfig()

const id = route.query.id
// Fields configuration
const numericFields = ref([
  { unit: "Kg", name: 'weight', label: 'Berat' },
  { unit: "Cm", name: 'height', label: 'Tinggi' },
  { unit: "Bulan", name: 'age_at_pregnancy', label: 'Usia Ibu Saat Hamil' },
]);
const selectedRecord = ref(null);

const booleanFields = ref([
  { unit: "", name: 'young_pregnant', label: 'Terlalu Muda Hamil di Usia < 16 Tahun', point: 4 },
  { unit: "", name: 'old_pregnant', label: 'Terlalu Tua, Hamil di Usia > 35', point: 4 },
  { unit: "", name: 'late_pregnant', label: 'Terlalu Lambat Hamil, kawin > 4 Tahun', point: 4 },
  { unit: "", name: 'early_pregnant', label: 'Terlalu Cepat Hamil Lagi, < 2 Tahun', point: 4 },
  //unit: "", { name: 'overlong_pregnant', label: 'Overlong Pregnant',point:4 },
  { unit: "", name: 'much_child', label: 'Terlalu Banyak Anak > 4', point: 4 },
  { unit: "", name: 'miscarriage', label: 'Pernah Keguguran', point: 4 },
  { unit: "", name: 'vacum_birth', label: 'Vacum Birth', point: 4 },
  { unit: "", name: 'retained_placenta', label: 'Retained Placenta', point: 4 },
  { unit: "", name: 'tranfused', label: 'Transfused', point: 4 },
  { unit: "", name: 'csection', label: 'C-Section', point: 8 },
  { unit: "", name: 'anemia', label: 'Anemia', point: 4 },
  { unit: "", name: 'malaria', label: 'Malaria', point: 4 },
  { unit: "", name: 'tbc', label: 'TBC', point: 4 },
  { unit: "", name: 'hearth_failure', label: 'Heart Failure', point: 4 },
  { unit: "", name: 'std', label: 'STD', point: 4 },
  { unit: "", name: 'hypertension', label: 'Hypertension', point: 4 },
  { unit: "", name: 'twin_birth', label: 'Twin Birth', point: 4 },
  { unit: "", name: 'hydranion', label: 'Hydranion', point: 4 },
  { unit: "", name: 'over_pregnant', label: 'Over Pregnant', point: 4 },
  { unit: "", name: 'death_baby', label: 'Bayi Meninggal Dalam Kandungan', point: 4 },
  { unit: "", name: 'breech', label: 'Sungsang', point: 8 },
  { unit: "", name: 'oblique', label: 'Lintang', point: 8 },
  { unit: "", name: 'preeklampsia', label: 'Preeklampsia', point: 8 },
]);

const allFields = ref([...numericFields.value, ...booleanFields.value]);

const records = ref([]);
const form = ref({
  young_pregnant: "",
  old_pregnant: "",
  late_pregnant: "",
  early_pregnant: "",
  overlong_pregnant: "",
  much_child: "",
  miscarriage: "",
  vacum_birth: "",
  retained_placenta: "",
  tranfused: "",
  csection: "",
  anemia: "",
  malaria: "",
  tbc: "",
  hearth_failure: "",
  std: "",
  hypertension: "",
  twin_birth: "",
  hydranion: "",
  over_pregnant: "",
  death_baby: "",
  breech: "",
  oblique: "",
  preeklampsia: ""
});
function calculatePoints(record) {
  let totalPoints = 0;

  booleanFields.value.forEach(field => {
    if (record[field.name] === 1) {
      totalPoints += field.point;
    }
  });

  return totalPoints;
}
console.log(form.value);


// Fetch all records from API
async function fetchRecords() {
  try {
    const response = await axios(`https://api.kaderpintar.id/api/pregnants/${id}`);
    const recordsWithPoints = {
      ...response.data,
      totalPoints: calculatePoints(response.data),
    };
    selectedRecord.value = recordsWithPoints;

  } catch (error) {
    console.error("Error fetching records:", error);
  }
}



// Format Boolean Values for Display
function formatValue(value) {
  if (value === true) return 'Ya';
  if (value === false) return 'Tidak';
  return value ?? '-';
}

// Fetch records on component mount
fetchRecords();
const recorded_by = ref("");
if (process.client) {
  form.recorded_by = JSON.parse(localStorage.getItem('user')).id
  recorded_by.value = JSON.parse(localStorage.getItem('user')).name


}
function formatDate(dateString) {
  const date = new Date(dateString);

  // Convert to WIB (UTC+7)
  const wibOffset = 7 * 60; // WIB is UTC+7
  const wibDate = new Date(date.getTime() + wibOffset * 60 * 1000);

  // Format the date
  const options = {
    year: 'numeric',
    month: '2-digit',
    day: '2-digit',
    hour: '2-digit',
    minute: '2-digit',
    second: '2-digit',
    timeZone: 'Asia/Jakarta'
  };

  const formattedDate = wibDate.toLocaleString('en-GB', options).replace(',', '');

  return formattedDate;
}
</script>