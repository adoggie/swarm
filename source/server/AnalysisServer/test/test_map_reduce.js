
//
// sec_op
// 时间是 ms 数，python 中是 s 数
//
var map = function () {
    array = this.CreatedDate.split('T'); 
    
    print (array[0]);
    var date = Date.parse(array[0])/1000;
    emit (date, 1);
};

var map = function () {
	if (this.Type != "New Customer") {

		array = this.CreatedDate.split('T');
		var date = Date.parse(array[0]) / 1000;
		emit(date, 1);
	}
};

db.sf_opportunity.mapReduce (map, reduce, {out: {inline:1}, limit:200, query:{'Account.Name': {'$exists':true},'CreatedDate' : {'$gte': '2015-06-01', '$lte': '2015-07-01'}}})

//
// service count
//
var map = function () {
	array = this.resolved_at.split('T'); 
    
    print (array[0]);
    var date = Date.parse(array[0])/1000;
    emit (date, 1);
};

var reduce = function (key, values) {
	var sum = 0;
	values.forEach(function(doc) {
		sum += 1;
	});
	return sum;
};

//
// service duration
//
var map = function () {
	var getDateVal = function (dateStr) {
		dateStr = dateStr.replace(/\D$/, '');
		dateStr = dateStr.replace('T', ' ');
		return dateStr
	};

	open = Date.parse(getDateVal(this.created_at))/1000;
	resolved = Date.parse(getDateVal(this.resolved_at))/1000;
	resolvedDate = Date.parse(this.resolved_at.split('T')[0])/1000;

	var dura = resolved - open;

	if (dura < 0)
		dura = 0;

	emit (resolvedDate, {value: dura, count:1});
};

var reduce = function (key, values) {
	res = {mean: 0, count: 0};

	sum = 0;
	values.forEach(function(doc) {
		if (doc.mean != undefined) {
			sum += doc.mean * doc.count;
			res.count += doc.count
		}
		else {
			sum += doc.value;
			res.count += 1
		}
	});

	res.mean = (sum / res.count).toFixed(0);
	return res;
};

var reduce = function (key, values) {
	res = {value: 0, count: 0};

	values.forEach(function(doc) {
		res.value += doc.value;
		res.count += doc.count
	});

	return res;
};

var finalize = function (key, result) {
	res = {mean: 0, count: result.count};
	res.mean = result.value / res.count;

	return res
};


db.desk_case.mapReduce (map, reduce, {out: {inline:1}, limit:200, query:{'status': 'resolved'} });


////////////////////////////////////////////////////////////////////////////////
//
// 一个 map reduce 解决所有问题
//
var map = function () {
	var getDateVal = function (dateStr) {
		dateStr = dateStr.replace(/\D$/, '');
		dateStr = dateStr.replace('T', ' ');
		return dateStr;
	};

	openStr = getDateVal (this.created_at);
	resolvedStr = getDateVal (this.resolved_at);

	open = Date.parse(openStr)/1000;
	resolved = Date.parse(resolvedStr)/1000;
	resolvedDate = Date.parse(resolvedStr.split(' ')[0])/1000;

	var dura = resolved - open;

	if (dura < 0 || isNaN(dura))
		dura = 0;

	if (isNaN(this.rating))
		rating = 4;
	else
		rating = this.rating;

	emit (resolvedDate, {dura: dura, rating: rating, count:1});
};

var reduce = function (key, values) {
	res = {dura: 0, rating:0, count: 0};

	values.forEach(function(doc) {
		res.dura += doc.dura;
		res.rating += doc.rating
		res.count += doc.count
	});

	return res;
};

var finalize = function (key, result) {
	res = {dura_mean: 0, rating_mean: 0, count: result.count};
	res.dura_mean = (result.dura / res.count).toFixed(0);
	res.rating_mean = (result.rating / res.count).toFixed(0);

	return res
};


//////////////////////////////////////////////////////////////////////////
//
// 尝试对 rating 分类
//

var map = function () {
	var getDateVal = function (dateStr) {
		dateStr = dateStr.replace(/\D$/, '');
		dateStr = dateStr.replace('T', ' ');
		return dateStr;
	};

	open = Date.parse(getDateVal(this.created_at))/1000;
	resolved = Date.parse(getDateVal(this.resolved_at))/1000;
	resolvedDate = Date.parse(getDateVal(this.resolved_at).split(' ')[0])/1000;

	var dura = resolved - open;

	if (dura < 0 || isNaN(dura))
		dura = 0;

	if (isNaN(this.rating) || this.rating == undefined)
		rating = 4;
	else
		rating = this.rating;

	var ratings = new Array();
	ratings.push({rating: rating, dura:dura, count:1});
	emit (resolvedDate, {count:1, ratings:ratings});
};


var reduce = function (key, values) {
	var ratings = new Array();
	var res = {count: 0, ratings: ratings};

	values.forEach(function(doc) {
		res.count += doc.count;
		for (var i = 0; i < doc.ratings.length; ++i) {
			var isNew = true;

			for (var j = 0; j < res.ratings.length; ++j) {
				if (doc.ratings[i].rating == res.ratings[j].rating) {
					++res.ratings[j].count;
					res.ratings[j].dura += doc.ratings[i].dura;

					isNew = false;
					break;
				}
			}

			if (isNew) {
				res.ratings.push(doc.ratings[i]);
			}
		}
	});

	return res;
};
