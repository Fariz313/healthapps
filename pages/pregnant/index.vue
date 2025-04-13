<template>
    <div class="container mt-5">
        <h1 class="mb-4">Data Ibu Hamil</h1>

        <!-- Form Tambah/Edit Data -->
        <div class="card mb-4">
            <div class="card-body">
                <h5 class="card-title">{{ isEditing ? 'Edit Data' : 'Tambah Data Baru' }}</h5>
                <form @submit.prevent="saveData">
                    <div class="row g-3">
                        <!-- User ID with VueMultiselect -->
                        <div class="col-md-6">
                            <label for="user_id" class="form-label">Pasien</label>
                            <VueMultiselect v-model="form.user_id" :options="userOptions" :searchable="true"
                                :loading="isFetchingUsers" label="name" track-by="id" placeholder="Cari user..."
                                @search-change="fetchUsers" />
                        </div>
                        <div class="col-md-6">
                            <label for="recorded_by" class="form-label">Nama Pendata</label>
                            <input v-model="recorded_by" readonly type="text" class="form-control" id="recorded_by">
                        </div>

                        <!-- Numeric Fields -->
                        <div class="col-md-4" v-for="field in numericFields" :key="field.name">
                            <label :for="field.name" class="form-label">{{ field.label }}</label>
                            <input v-model="form[field.name]" type="number" step="0.1" class="form-control"
                                :id="field.name">
                        </div>

                        <!-- Boolean Fields -->
                        <div class="col-md-6" v-for="field in booleanFields" :key="field.name">
                            <label class="form-label">{{ field.label }}</label>
                            <select v-model="form[field.name]" class="form-select">
                                <option disabled selected>Pilih</option>
                                <option :value="true">Ya</option>
                                <option :value="false">Tidak</option>
                            </select>
                        </div>
                    </div>

                    <button type="submit" class="btn btn-primary mt-3">
                        {{ isEditing ? 'Update Data' : 'Tambah Data' }}
                    </button>
                    <button v-if="isEditing" type="button" class="btn btn-secondary mt-3 ms-2" @click="cancelEdit">
                        Batal
                    </button>
                </form>
            </div>
        </div>

        <!-- List Data dalam Card -->
        <div class="row">
            <div v-for="record in records" :key="record.id" class="col-md-6 col-lg-4 mb-4">
                <div class="card">
                    <div class="card-body">
                        <h5 class="card-title">Pasien: {{ record.name }}</h5>
                        <div v-if="record.totalPoints < 6" class="alert alert-success" role="alert">
                            <b>Resiko Rendah</b>
                        </div>
                        <div v-else-if="record.totalPoints < 12" class="alert alert-warning" role="alert">
                            <b>Resiko Tinggi</b>
                        </div>
                        <div v-else class="alert alert-danger" role="alert">
                            <b>Resiko Sangat Tinggi</b>
                        </div>
                        <p class="card-text">
                            <strong>Petugas:</strong> {{ record.recorded_by }}<br>
                            <strong>Tanggal:</strong> {{ formatDate(record.created_at) }}<br>
                            <!-- Tampilkan beberapa field saja di card -->
                            <strong>Berat:</strong> {{ record.weight }} kg<br>
                            <strong>Tinggi:</strong> {{ record.height }} cm<br>
                            <strong>Usia Ibu Saat Hamil:</strong> {{ record.age_at_pregnancy }}<br>
                        </p>
                        <button class="btn btn-danger btn-sm p-1 px-2  me-2"
                            @click="deleteData(record.id)">Hapus</button>
                        <button class="btn btn-info btn-sm p-1 px-2 me-2" data-bs-toggle="modal"
                            data-bs-target="#detailModal" @click="openDetailModal(record)">
                            Detail
                        </button>
                    </div>
                </div>
            </div>
        </div>

        <div class="modal fade" id="detailModal" tabindex="-1" aria-labelledby="detailModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-xl">
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
                                    <p class="text-danger" v-if="(selectedRecord[field.name] == 1)"><strong
                                            class="text-dark">{{ field.label }}:</strong> {{
                                                formatValue((selectedRecord[field.name]==1)) }}</p>
                                    <p class="text-success" v-if="(selectedRecord[field.name] != 1)"><strong
                                            class="text-dark">{{ field.label }}:</strong> {{
                                                formatValue((selectedRecord[field.name]==1)) }}</p>
                                </div>
                                <div v-else>
                                    <p> <strong>{{ field.label }} :</strong> {{ selectedRecord[field.name] }} {{ field.unit }}
                                    </p>
                                </div>
                            </template>
                        </template>
                    </div>
                    <div class="modal-footer">
                        <button type="button" class="btn btn-outline-primary" @click="copyLink">Copy Link</button>
                        <button type="button" class="btn btn-outline-success" @click="shareLink">Share Link</button>
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Tutup</button>
                    </div>
                </div>
            </div>
        </div>
    </div>
</template>

<script setup>
import { ref } from 'vue';
import VueMultiselect from 'vue-multiselect';
const runtimeConfig = useRuntimeConfig();

const selectedUser = ref(null);
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
console.log(form.value);

// User selection data
const userOptions = ref([]);
const isFetchingUsers = ref(false);

// Fetch all records from API
async function fetchRecords() {
    try {
        const response = await useFetch('https://api.kaderpintar.id/api/pregnants');
        const recordsWithPoints = response.data.value?.data.data.map(record => {
            return {
                ...record,
                totalPoints: calculatePoints(record),
            };
        });
        records.value = recordsWithPoints;

    } catch (error) {
        console.error("Error fetching records:", error);
    }
}

// Fetch users from API
async function fetchUsers(query) {
    if (!query) return;
    isFetchingUsers.value = true;
    try {
        const response = await fetch(`https://api.kaderpintar.id/api/users?search=${query}`);
        const data = await response.json();
        userOptions.value = data.data.data.map(user => ({ id: user.id, name: user.name }));

    } catch (error) {
        console.error("Error fetching users:", error);
    } finally {
        isFetchingUsers.value = false;
    }
}

// Save or update data
async function saveData() {
    try {
        const url = isEditing.value
            ? `https://api.kaderpintar.id/api/pregnants/${form.value.id}`
            : 'https://api.kaderpintar.id/api/pregnants';

        const method = isEditing.value ? 'PUT' : 'POST';
        let body = form.value
        body.user_id = form.value.user_id.id
        const data = await useFetch(url, {
            method,
            headers: {
                'Content-Type': 'application/json',
            },
            body: JSON.stringify(body),
        });
        const response = data.data.value;

        if (data.status.value != "success") throw new Error("Gagal menyimpan data.");

        fetchRecords(); // Refresh data
        resetForm();
    } catch (error) {
        console.error("Error saving data:", error);
    }
}

// Edit Data
function editData(record) {
    form.value = { ...record };
    isEditing.value = true;
}
function cancelEdit() {
    form.value = {
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
    }
    isEditing.value = false;

}
// Delete Data
async function deleteData(id) {
    try {
        const response = await fetch(`https://api.kaderpintar.id/api/pregnants/${id}`, {
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


function getDetailLink() {
  const baseUrl = runtimeConfig.public.siteUrl || 'http://localhost:3000'; // fallback
  return `${baseUrl}/pregnant/${selectedRecord.value?.id}`;
}

function copyLink() {
  const link = getDetailLink();
  navigator.clipboard.writeText(link)
    .then(() => alert('Link berhasil disalin!'))
    .catch(err => alert('Gagal menyalin: ' + err));
}

function shareLink() {
  const link = getDetailLink();
  if (navigator.share) {
    navigator.share({
      title: 'Detail Data Pasien',
      text: 'Lihat detail data pasien di link berikut:',
      url: link
    }).catch(err => alert('Gagal membagikan: ' + err));
  } else {
    alert('Fitur berbagi tidak didukung di perangkat ini.');
  }
}
</script>