<template>
  <ClientOnly>
    <div class="modal-content">
      <div class="modal-header">
        <h5 class="modal-title" id="detailModalLabel">Detail Data Pasien</h5>
        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
      </div>
      <div class="modal-body">
        <template v-if="(selectedRecord)">
          <p><strong>Pasien:</strong> {{ selectedRecord.name }}</p>
          <p><strong>Recorded By:</strong> {{ selectedRecord.recorded_by }}</p>
          <p><strong>Tanggal:</strong> {{ formatDate(selectedRecord.created_at) }}</p>

          <template v-for="field in allFields" :key="field.name">

            <div>
              <p> <strong>{{ field.label }} :</strong> {{ selectedRecord[field.name] }} {{ field.unit }}
              </p>
            </div>
          </template>

          <h4>Hasil Kalkulasi & Rekomendasi:</h4>
          <ul>
            <li>
              <div>
                <b>Berat Badan
                  menurut Umur :</b>
                <p v-if="selectedRecord.weight < searchByKey(BBU_L, 'age', selectedRecord.age)?.m3sd">
                  Berat badan sangat
                  kurang (severely
                  underweight)
                </p>
                <p
                  v-else-if="selectedRecord.weight > searchByKey(BBU_L, 'age', selectedRecord.age)?.m3sd && selectedRecord.weight < searchByKey(BBU_L, 'age', selectedRecord.age)?.m2sd">
                  Berat badan kurang
                  (underweight)
                </p>
                <p
                  v-else-if="selectedRecord.weight > searchByKey(BBU_L, 'age', selectedRecord.age)?.m2sd && selectedRecord.weight < searchByKey(BBU_L, 'age', selectedRecord.age)?.p1sd">
                  Berat badan normal
                </p>
                <p v-else>
                  Risiko Berat badan lebih
                </p>
              </div>
            </li>
            <li>
              <div>
                <b>Panjang Badan
                  atau Tinggi Badan
                  menurut Umur :</b>
                <p v-if="selectedRecord.height < searchByKey(TBU_L, 'age', selectedRecord.age)?.m3sd">
                  Sangat Pendek
                </p>
                <p
                  v-else-if="selectedRecord.height > searchByKey(TBU_L, 'age', selectedRecord.age)?.m3sd && selectedRecord.height < searchByKey(BBU_L, 'age', selectedRecord.age)?.m2sd">
                  Pendek
                </p>
                <p
                  v-else-if="selectedRecord.height > searchByKey(TBU_L, 'age', selectedRecord.age)?.m2sd && selectedRecord.height < searchByKey(BBU_L, 'age', selectedRecord.age)?.p1sd">
                  Normal
                </p>
                <p v-else>
                  Tinggi
                </p>
              </div>
            </li>
            <li>
              <div>
                <b>Indeks Massa
                  Tubuh menurut
                  Umurr :</b>
                <p
                  v-if="(selectedRecord.weight / selectedRecord.height) < searchByKey(TBU_L, 'age', selectedRecord.age)?.m3sd">
                  Gizi Buruk
                </p>
                <p
                  v-else-if="(selectedRecord.weight / selectedRecord.height) > searchByKey(TBU_L, 'age', selectedRecord.age)?.m3sd && (selectedRecord.weight / selectedRecord.height) < searchByKey(BBU_L, 'age', selectedRecord.age)?.m2sd">
                  Gizi Kurang
                </p>
                <p
                  v-else-if="(selectedRecord.weight / selectedRecord.height) > searchByKey(TBU_L, 'age', selectedRecord.age)?.m2sd && (selectedRecord.weight / selectedRecord.height) < searchByKey(BBU_L, 'age', selectedRecord.age)?.p1sd">
                  Gizi Lebih
                </p>
                <p v-else>
                  Obesitas
                </p>
              </div>
            </li>
          </ul>
        </template>
      </div>
      <div class="modal-footer">
        <div class="mt-6">
          <span class="font-semibold text-base mb-2">Bagikan atau Simpan QR</span> <br>
            <qrcode-vue :value="url" :size="150" />
        </div>
      </div>
    </div>
  </ClientOnly>
</template>

<script setup>
import axios from 'axios';
import { ref } from 'vue';
import QrcodeVue from 'qrcode.vue'

const route = useRoute()
const { public: config } = useRuntimeConfig()

const id = route.query.id
// Fields configuration
const numericFields = ref([
  { unit: "Kg", name: 'weight', label: 'Berat', readonly: false },
  { unit: "Cm", name: 'height', label: 'Tinggi', readonly: false },
  { unit: "bulan", name: 'age', label: 'Usia saat ini', readonly: true, custom: 'usia' }
]);
const selectedRecord = ref(null);

const booleanFields = ref([]);

const allFields = ref([...numericFields.value, ...booleanFields.value]);

const records = ref([]);
const form = ref({
  weight: "",
  height: "",
  age: "",
});
const isEditing = ref(false);
function calculatePoints(record) {
  let totalPoints = 0;

  booleanFields.value.forEach(field => {
    if (record[field.name] === 1) {
      totalPoints += field.point;
    }
  });

  return totalPoints;
}
const userOptions = ref([]);
// Fetch all records from API
async function fetchRecords() {
  try {

    const request = await axios.get(`https://api.kaderpintar.id/api/gizi/${id}`);
    selectedRecord.value = request.data;

  } catch (error) {
    console.error("Error fetching records:", error);
  }
}

function cancelEdit() {
  form.value = {
    weight: "",
    height: "",
  }
  isEditing.value = false;

}
// Delete Data
async function deleteData(id) {
  try {
    const response = await fetch(`https://api.kaderpintar.id/api/gizi/${id}`, {
      method: 'DELETE',
    });

    if (!response.ok) throw new Error("Gagal menghapus data.");

    fetchRecords(); // Refresh data
  } catch (error) {
    console.error("Error deleting data:", error);
  }
}

// Reset Form
function resetForm() {
  form.value = {};
  isEditing.value = false;
}

// Format Boolean Values for Display
function formatValue(value) {
  if (value === true) return 'Ya';
  if (value === false) return 'Tidak';
  return value ?? '-';
}
function openDetailModal(record) {
  selectedRecord.value = record;
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

function calculateAgeInMonths(birthDate) {
  const today = new Date();
  const birthDateObj = new Date(birthDate);

  const yearDiff = today.getFullYear() - birthDateObj.getFullYear();
  const monthDiff = today.getMonth() - birthDateObj.getMonth();
  const dayDiff = today.getDate() - birthDateObj.getDate();

  let ageInMonths = yearDiff * 12 + monthDiff;

  // If the birth date hasn't passed this year yet, subtract 1 month
  if (monthDiff < 0 || (monthDiff === 0 && dayDiff < 0)) {
    ageInMonths--;
  }

  return ageInMonths;
}
watch(() => form.value.user_id, (newUserId) => {
  if (newUserId) {
    const selectedUser = userOptions.value.find(user => user.id === newUserId.id);
    if (selectedUser) {
      form.value.age = calculateAgeInMonths(selectedUser.birth_date);
    }
  } else {
    form.value.age = ""; // Reset age jika tidak ada user yang dipilih
  }
});

const BBPB_L = ref({});
const BBPB_P = ref({});
const BBTB_L = ref({});
const BBTB_P = ref({});
const BBU_L = ref({});
const BBU_P = ref({});
const IMTU_L = ref({});
const IMTU_P = ref({});
const TBU_L = ref({});
const TBU_P = ref({});
async function fetchCalculate() {
  try {
    const BBPB_L_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBPB_L.json');
    const BBPB_P_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBPB_P.json');
    const BBTB_L_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBTB_L.json');
    const BBTB_P_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBTB_P.json');
    const BBU_L_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBU_L.json');
    const BBU_P_req = await fetch('https://kaderpintar.id/assets/json/gizi/BBU_P.json');
    const IMTU_L_req = await fetch('https://kaderpintar.id/assets/json/gizi/IMTU_L.json');
    const IMTU_P_req = await fetch('https://kaderpintar.id/assets/json/gizi/IMTU_P.json');
    const TBU_L_req = await fetch('https://kaderpintar.id/assets/json/gizi/TBU_L.json');
    const TBU_P_req = await fetch('https://kaderpintar.id/assets/json/gizi/TBU_P.json');
    BBPB_L.value = await BBPB_L_req.json();
    BBPB_P.value = await BBPB_P_req.json();
    BBTB_L.value = await BBTB_L_req.json();
    BBTB_P.value = await BBTB_P_req.json();
    BBU_L.value = await BBU_L_req.json();
    BBU_P.value = await BBU_P_req.json();
    IMTU_L.value = await IMTU_L_req.json();
    IMTU_P.value = await IMTU_P_req.json();
    TBU_L.value = await TBU_L_req.json();
    TBU_P.value = await TBU_P_req.json();

  } catch (error) {
    console.error('Error fetching BBPB_L.json:', error);
    return null;
  }
}
function searchByKey(data, key, searchValue) {
  console.log("DF");
  console.log(data);

  // Check if data is an array before calling filter
  if (!Array.isArray(data)) {
    console.error('Expected data to be an array but got', typeof data);
    return null; // or handle the error as needed
  }

  return data.filter(item => {
    // If the value of the key is a string, do a case-insensitive search
    if (typeof item[key] === 'string') {
      return item[key].toLowerCase().includes(searchValue.toLowerCase());
    }
    // If the value of the key is a number, do an exact match search
    return item[key] === searchValue;
  })[0]; // Return the first match (or undefined if not found)
}
console.log("getrecord");
await fetchRecords(); // Refresh data
console.log("getrecord done");
if (process.client) {
fetchCalculate();
}
</script>

<style scoped>
.container {
  max-width: 800px;
}
</style>