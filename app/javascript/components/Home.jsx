import React, { useEffect, useState } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import { PaginationControl } from 'react-bootstrap-pagination-control';
import CompaniesTable from "./CompaniesTable";
import { useDebounce } from 'use-debounce';

export default () => {
  // List of fetched companies
  const [companies, setCompanies] = useState([]);

  // Table filters
  const [companyName, setCompanyName] = useState("");
  const [industry, setIndustry] = useState("");
  const [minEmployee, setMinEmployee] = useState("");
  const [minimumDealAmount, setMinimumDealAmount] = useState("");
  const [page, setPage] = useState(1);
  const [totalRecordsCount, setTotalRecordsCount] = useState(0);

  const debouncedValues = [
    useDebounce(companyName, 250)[0],
    useDebounce(industry, 250)[0],
    useDebounce(minEmployee, 250)[0],
    useDebounce(minimumDealAmount, 250)[0]
  ]

  const perPage = 10;

  // Fetch companies from API
  useEffect(() => {
    const url = "/api/v1/companies?" + query();
    fetch(url)
      .then((res) => {
        if(res.ok) {
          return res.json().then((res) => {
            setCompanies(res.records);
            setTotalRecordsCount(res.total_records_count);
          })
        } else {
          return res.json().then((res) => {
            console.error(res.error);
            alert(res.error);
          })
        }
      })
      .catch(error => {
        const msg = `Error: ${error.message}`
        console.error(msg);
        alert(msg);
      })
  }, debouncedValues.concat([page]))

  const query = () => {
    const params = new URLSearchParams({
      company_name: companyName,
      industry_name: industry,
      min_employee_count: minEmployee,
      min_deal_amount: minimumDealAmount,
      page: page,
      per_page: perPage,
      api_token: sessionStorage.getItem("apiToken")
    });
    return params.toString();
  }

  return (
    <div className="vw-100 primary-color d-flex align-items-center justify-content-center">
      <div className="jumbotron jumbotron-fluid bg-transparent">
        <div className="container secondary-color">
          <h1 className="display-4">Companies</h1>

          <div id="filters" >
            <label htmlFor="company-name">Company Name</label>
            <div className="input-group mb-3">
              <input type="text" className="form-control" id="company-name" value={companyName} onChange={e => setCompanyName(e.target.value)} />
            </div>

            <label htmlFor="industry">Industry</label>
            <div className="input-group mb-3">
              <input type="text" className="form-control" id="industry" value={industry} onChange={e => setIndustry(e.target.value)} />
            </div>

            <label htmlFor="min-employee">Minimum Employee Count</label>
            <div className="input-group mb-3">
              <input type="text" className="form-control" id="min-employee" value={minEmployee} onChange={e => setMinEmployee(e.target.value)} />
            </div>

            <label htmlFor="min-amount">Minimum Deal Amount</label>
            <div className="input-group mb-3">
              <input type="text" className="form-control" id="min-amount" value={minimumDealAmount} onChange={e => setMinimumDealAmount(e.target.value)} />
            </div>
          </div>

          < CompaniesTable companies={companies} />

          <PaginationControl
            page={page}
            total={totalRecordsCount}
            limit={perPage}
            changePage={(page) => {
              setPage(page)
            }}
          />
        </div>
      </div>
    </div>
  )
};
