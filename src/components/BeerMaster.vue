<template>
  <div>

        <b-container fluid>
            <!-- User Interface controls -->
            <b-row>
                <b-col lg="12" class="my-1">
                    <b-form inline>
                      <label class="mr-sm-2" for="inline-form-custom-select-pref">La mejor</label>
                      <b-form-select
                        id="inline-form-custom-select-pref"
                        class="mb-2 mr-sm-2 mb-sm-0"
                        :options="options"
                        v-model="selected"
                      ></b-form-select>
                      <b-form-select
                        id="inline-form-custom-select-pref"
                        class="mb-2 mr-sm-2 mb-sm-0"
                        @change="onChangeCountry"
                        :options="countries"
                        v-model="country_selected"
                      ></b-form-select>
                      <!-- <b-button variant="success">Buscar</b-button> -->
                    </b-form>
                  </b-col>
            </b-row>

            <!-- Main table element -->
            <b-table
              class="beermaster-table"
              show-empty
              small
              stacked="md"
              :items="items"
              :fields="fields"
              :current-page="currentPage"
              :per-page="perPage"
              :filter="filter"
              :filterIncludedFields="filterOn"
              :sort-by.sync="sortBy"
              :sort-desc.sync="sortDesc"
              :sort-direction="sortDirection"
              @filtered="onFiltered"
            >
              <template v-slot:cell(name)="row">
                {{ row.value.first }} {{ row.value.last }}
              </template>

              <template v-slot:cell(actions)="row">
                <b-button size="sm" @click="info(row.item, row.index, $event.target)" class="mr-1">
                  <i class="fas fa-info-circle"></i>
                </b-button>
                <b-button size="sm" @click="row.toggleDetails">
                  <i class="fas fa-thumbs-up"></i>
                </b-button>
                <!-- <b-button size="sm" @click="row.toggleDetails">
                  {{ row.detailsShowing ? 'Ocultar' : 'Mostrar' }}
                </b-button> -->
                <b-button size="sm" variant="info" @click="row.toggleDetails">
                  <i class="fas fa-cart-plus mr-1"></i>
                </b-button>

              </template>

              <template v-slot:row-details="row">
                <b-card>
                  <ul>
                    <li v-for="(value, key) in row.item" :key="key">{{ key }}: {{ value }}</li>
                  </ul>
                </b-card>
              </template>
            </b-table>

            <b-row>

              <b-col lg="6" class="my-1">
                <b-form-group
                  label="Filter"
                  label-cols-sm="3"
                  label-align-sm="right"
                  label-size="sm"
                  label-for="filterInput"
                  class="mb-0"
                >
                  <b-input-group size="sm">
                    <b-form-input
                      v-model="filter"
                      type="search"
                      id="filterInput"
                      placeholder="Buscar en la tabla"
                    ></b-form-input>
                    <b-input-group-append>
                      <b-button :disabled="!filter" @click="filter = ''">Borrar</b-button>
                    </b-input-group-append>
                  </b-input-group>
                </b-form-group>
              </b-col>

              <b-col sm="5" md="6" class="my-1">
                <b-form-group
                  label="Per page"
                  label-cols-sm="6"
                  label-cols-md="4"
                  label-cols-lg="3"
                  label-align-sm="right"
                  label-size="sm"
                  label-for="perPageSelect"
                  class="mb-0"
                >
                  <b-form-select
                    v-model="perPage"
                    id="perPageSelect"
                    size="sm"
                    :options="pageOptions"
                  ></b-form-select>
                </b-form-group>
              </b-col>

              <b-col sm="7" md="6" class="my-1">
                <b-pagination
                  v-model="currentPage"
                  :total-rows="totalRows"
                  :per-page="perPage"
                  align="fill"
                  size="sm"
                  class="my-0"
                ></b-pagination>
              </b-col>
            </b-row>

            <!-- Info modal -->
            <b-modal :id="infoModal.id" :title="infoModal.title" ok-only @hide="resetInfoModal">
              <pre>{{ infoModal.content }}</pre>
            </b-modal>
          </b-container>



  </div>
</template>
<style scoped>
  .beermaster-table td{
    vertical-align: middle;
  }
</style>
<script>
import Axios from 'axios';

export default {
  data () {
    return {
      selected: 'ipa',
      options: [
        { value: 'ipa', text: 'IPA' },
        { value: 'ale', text: 'Ale', disabled: true },
        { value: 'kellerbier', text: 'Kellerbier' },
        { value: 'lager', text: 'Lager' },
        { value: 'bock', text: 'Bock' },
        { value: 'kolsch', text: 'Kölsch' },
        { value: 'pilsener', text: 'Pilsener' },
        { value: 'porter', text: 'Porter' },
        { value: 'stout', text: 'Stout' },
        { value: 'weissbier', text: 'Weissbier' },
      ],
      country_selected: '/',
      countries: [
        { value: '/', text: 'Del Mundo' },
        { value: '/uruguay', text: 'De Uruguay' },
        { value: '/usa', text: 'De USA' },
      ],

      items: [
        { isActive: true, age: 40, name: { first: 'Dickerson', last: 'Macdonald' } },
        { isActive: false, age: 21, name: { first: 'Larsen', last: 'Shaw' } },
        {
          isActive: false,
          age: 9,
          name: { first: 'Mini', last: 'Navarro' },
          _rowVariant: 'success'
        },
        { isActive: false, age: 89, name: { first: 'Geneva', last: 'Wilson' } },
        { isActive: true, age: 38, name: { first: 'Jami', last: 'Carney' } },
        { isActive: false, age: 27, name: { first: 'Essie', last: 'Dunlap' } },
        { isActive: true, age: 40, name: { first: 'Thor', last: 'Macdonald' } },
        {
          isActive: true,
          age: 87,
          name: { first: 'Larsen', last: 'Shaw' },
          _cellVariants: { age: 'danger', isActive: 'warning' }
        },
        { isActive: false, age: 26, name: { first: 'Mitzi', last: 'Navarro' } },
        { isActive: false, age: 22, name: { first: 'Genevieve', last: 'Wilson' } },
        { isActive: true, age: 38, name: { first: 'John', last: 'Carney' } },
        { isActive: false, age: 29, name: { first: 'Dick', last: 'Dunlap' } }
      ],
      fields: [
         { key: 'name', label: 'Person Full name', sortable: true, sortDirection: 'desc' },
         { key: 'age', label: 'Person age', sortable: true, class: 'text-center' },
         {
           key: 'isActive',
           label: 'is Active',
           formatter: (value, key, item) => {
             return value ? 'Yes' : 'No'
           },
           sortable: true,
           sortByFormatted: true,
           filterByFormatted: true
         },
         { key: 'actions', label: 'Actions' }
       ],
       totalRows: 1,
       currentPage: 1,
       perPage: 5,
       pageOptions: [5, 10, 15],
       sortBy: '',
       sortDesc: false,
       sortDirection: 'asc',
       filter: null,
       filterOn: [],
       infoModal: {
         id: 'info-modal',
         title: '',
         content: ''
       }
    }
  },
  computed: {
    sortOptions() {
      // Create an options list from our fields
      return this.fields
        .filter(f => f.sortable)
        .map(f => {
          return { text: f.label, value: f.key }
        })
    }
  },
  mounted() {
    // Set the initial number of items
    this.totalRows = this.items.length
  },
  methods: {
    info(item, index, button) {
      this.infoModal.title = `Row index: ${index}`
      this.infoModal.content = JSON.stringify(item, null, 2)
      this.$root.$emit('bv::show::modal', this.infoModal.id, button)
    },
    resetInfoModal() {
      this.infoModal.title = ''
      this.infoModal.content = ''
    },
    onFiltered(filteredItems) {
      // Trigger pagination to update the number of buttons/pages due to filtering
      this.totalRows = filteredItems.length
      this.currentPage = 1
    },
    onChangeCountry(value) {
      // alert(value);
      // router.push(value);

      this.$router.push(value);

      // console.log(this.$router);
    }
  },
  watch: {
    $route(to, from) {
      this.country_selected = to.path;
      // react to route changes...
    }
  }
}
</script>
