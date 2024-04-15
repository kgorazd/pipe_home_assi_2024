import React, { useEffect, useState } from "react";
import 'bootstrap/dist/css/bootstrap.min.css';
import { PaginationControl } from 'react-bootstrap-pagination-control';

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

  const perPage = 10;

  // Fetch companies from API
  useEffect(() => {
    const url = "/api/v1/companies?" + query();
    fetch(url)
      .then((res) => {
        return res.json();
      })
      .then((res) => {
        setCompanies(res.records);
        setTotalRecordsCount(res.total_records_count);
      });
  }, [companyName, industry, minEmployee, minimumDealAmount, page])

  const query = () => {
    const params = new URLSearchParams({
      company_name: companyName,
      industry_name: industry,
      min_employee_count: minEmployee,
      min_deal_amount: minimumDealAmount,
      page: page,
      per_page: perPage
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

          <table className="table">
            <thead>
              <tr>
                <th scope="col">Name</th>
                <th scope="col">Industry</th>
                <th scope="col">Employee Count</th>
                <th scope="col">Total Deal Amount</th>
              </tr>
            </thead>
            <tbody>
              {companies.map((company) => (
                <tr key={company.id}>
                  <td>{company.name}</td>
                  <td>{company.industry}</td>
                  <td>{company.employee_count}</td>
                  <td>{company.total_deal_amount}</td>
                </tr>
              ))}
            </tbody>
          </table>
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
