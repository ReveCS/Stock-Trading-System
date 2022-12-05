<%@ page language="java" contentType="text/html; charset=ISO-8859-1" pageEncoding="ISO-8859-1" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<c:set var="heading" value="Home"/>
<%@ include file="header.jsp" %>
<div class="container">
    <h2>Summary Listing</h2>
    <h3>Search Stock Symbol, Stock Type or Customer ID:</h3>
    <form action="getSummaryListing">
        <input type="text" name="searchKeyword" placeholder="Stock Symbol or Stock Type or Customer ID"
               class="form-control"/>
        <div class="form-group">
            <label for="keywordType">Keyword Type:</label>
            <select class="form-control" name="keywordType">
            	<option value="Stock Symbol"> <c:out value = "Stock Symbol"/></option>
            	<option value="Stock Type"> <c:out value = "Stock Type"/></option>
            	<option value="Customer Name"> <c:out value = "Customer ID"/></option>
            </select>
        </div>
        <input type="submit" value="Search" class="btn btn-success"/>
    </form>
</div>
<%@ include file="footer.jsp" %>