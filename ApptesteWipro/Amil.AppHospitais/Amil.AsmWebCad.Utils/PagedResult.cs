using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Runtime.Serialization;

namespace Amil.AsmWebCad.Utils
{
    public static class PagedResultHelpers
    {
        public static PagedResult<T> ToPagedResult<T>(this IEnumerable<T> source, int offset, int limit, string order)
        {
            var result = new PagedResult<T>(source, offset, limit, order);
            return result;
        }

        public static PagedResult<TResult> ToPagedResult<TSource, TResult>(this IQueryable<TSource> source
                                                                                  , int offset, int limit, string order
                                                                                  , Expression<Func<TSource, TResult>> processResult)
        {
            var result = new PagedResult<TSource, TResult>(source, offset, limit, order, processResult);
            return result;
        }
    }

    [DataContract(Name = "PagedResultOf{0}")]
    [Serializable]
    public class PagedResult<TResult>
    {
        public PagedResult()
        {
            Items = new List<TResult>();
        }

        public PagedResult(IEnumerable<TResult> source, int offset, int limit, string order)
            : this(source.AsQueryable(), offset, limit, order)
        {
        }

        public PagedResult(IQueryable<TResult> source, int offset, int limit, string order)
            : this()
        {
            Process(source, offset, limit, order, (parsedSource) =>
            {
                var result = Queryable.Take(Queryable.Skip(parsedSource, Offset), Limit).ToList();
                Items.AddRange(result);
            });
        }

        protected virtual void Process<T>(IQueryable<T> source, int offset, int limit, string order, Action<IQueryable<T>> afterProcess)
        {
            if (offset < 0)
                throw new ArgumentOutOfRangeException("offset", "Value must to be greater than 0.");
            if (limit < 1)
                throw new ArgumentOutOfRangeException("limit", "Value must to be greater than 1.");

            if (source == null)
                source = new List<T>().AsQueryable();

            Offset = offset;
            Limit = limit;

            TotalCount = Queryable.Count(source);

            if (TotalCount > 0 && TotalCount >= Offset)
            {
                if (!string.IsNullOrWhiteSpace(order)) //order especificada, então aplica
                {
                    source = source.OrderByMultiLevel(order);
                }
                else if (!source.IsOrdered() && string.IsNullOrWhiteSpace(order)) //ainda nao ordenado e sem order especificada
                {
                    throw new ArgumentException("'order' parameter must to be specified or source object must to be previously ordered", "order");
                }

                afterProcess(source);
            }
        }

        [DataMember]
        public int Offset { get; set; }

        [DataMember]
        public int Limit { get; set; }

        [DataMember]
        public int TotalCount { get; set; }

        [DataMember]
        public List<TResult> Items { get; set; }
    }

    public class PagedResult<TSource, TResult> : PagedResult<TResult>
    {
        public PagedResult(IQueryable<TSource> source, int offset, int limit, string order, Expression<Func<TSource, TResult>> processResult)
        {
            Process(source, offset, limit, order, (parsedSource) =>
            {
                var preResult = Queryable.Take(Queryable.Skip(parsedSource, Offset), Limit);
                var result = preResult.Select(processResult).ToList();
                Items.AddRange(result);
            });
        }
    }
}
