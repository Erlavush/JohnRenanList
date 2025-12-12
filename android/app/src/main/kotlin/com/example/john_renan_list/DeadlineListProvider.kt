package com.example.john_renan_list

import android.content.Context
import android.content.Intent
import android.widget.RemoteViews
import android.widget.RemoteViewsService
import es.antonborri.home_widget.HomeWidgetPlugin
import org.json.JSONArray
import org.json.JSONObject
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale

class DeadlineListProvider(val context: Context, intent: Intent) : RemoteViewsService.RemoteViewsFactory {
    private var data = JSONArray()

    override fun onCreate() {
        // Initial load
    }

    override fun onDataSetChanged() {
        val widgetData = HomeWidgetPlugin.getData(context)
        val jsonString = widgetData.getString("full_schedule_json", "[]")
        try {
            data = JSONArray(jsonString)
        } catch (e: Exception) {
            data = JSONArray()
        }
    }

    override fun onDestroy() {
        // Clear data
    }

    override fun getCount(): Int {
        return data.length()
    }

    override fun getViewAt(position: Int): RemoteViews {
        val views = RemoteViews(context.packageName, R.layout.widget_item)
        
        try {
            val item = data.getJSONObject(position)
            
            // Parse Subject into Dept/Num
            val subject = item.getString("subject")
            var dept = subject
            var num = ""
            
            if (subject.contains(" ")) {
                val parts = subject.split(" ")
                dept = parts[0]
                if (parts.size > 1) num = parts.subList(1, parts.size).joinToString(" ")
            } else if (subject.contains("-")) {
                val parts = subject.split("-")
                dept = parts[0]
                if (parts.size > 1) num = parts[1]
            }

            views.setTextViewText(R.id.widget_item_dept, dept)
            views.setTextViewText(R.id.widget_item_num, num)
            views.setTextViewText(R.id.widget_item_title, item.getString("title"))

            // Time calculation
            val deadlineMillis = item.getLong("deadline")
            val now = System.currentTimeMillis()
            val diff = deadlineMillis - now
            
            val days = diff / (1000 * 60 * 60 * 24)
            val hours = (diff / (1000 * 60 * 60)) % 24
            
            val timeText = if (diff < 0) {
                "Done"
            } else if (days > 0) {
                "$days Days"
            } else {
                "$hours Hours"
            }
            
            views.setTextViewText(R.id.widget_item_time, timeText)

        } catch (e: Exception) {
            e.printStackTrace()
        }

        return views
    }

    override fun getLoadingView(): RemoteViews? {
        return null
    }

    override fun getViewTypeCount(): Int {
        return 1
    }

    override fun getItemId(position: Int): Long {
        return position.toLong()
    }

    override fun hasStableIds(): Boolean {
        return true
    }
}
