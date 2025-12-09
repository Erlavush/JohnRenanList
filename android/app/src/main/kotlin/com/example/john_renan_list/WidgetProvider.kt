package com.example.john_renan_list

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.widget.RemoteViews
import es.antonborri.home_widget.HomeWidgetPlugin
import android.os.SystemClock

class WidgetProvider : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        for (appWidgetId in appWidgetIds) {
            val views = RemoteViews(context.packageName, R.layout.widget_layout)
            
            // Get data from SharedPreferences (set by Flutter HomeWidget plugin)
            val widgetData = HomeWidgetPlugin.getData(context)
            val deadlineMillis = widgetData.getLong("deadline", 0)
            val title = widgetData.getString("title", "No Assignments")
            val subject = widgetData.getString("subject", "")

            views.setTextViewText(R.id.widget_title, subject)
            views.setTextViewText(R.id.widget_subject, title)

            if (deadlineMillis > 0) {
                // Calculate base for Chronometer (it expects boot time relative or absolute depending on implementation, 
                // but standard Chronometer usage for countdown matches system clock)
                // Actually Chronometer uses SystemClock.elapsedRealtime() for base usually if strictly time based 
                // but here we want a countdown to a set date.
                // Chronometer in RemoteViews is tricky. 
                // Documentation says: `setBase` sets the time that the count-up timer is in reference to.
                // For countdown to a date, we calculate the offset.
                // However, RemoteViews Chronometer support is limited.
                // Correct approach: setBase(SystemClock.elapsedRealtime() + (deadline - now))
                
                val now = System.currentTimeMillis()
                val timeRemaining = deadlineMillis - now
                views.setChronometer(R.id.widget_chronometer, SystemClock.elapsedRealtime() + timeRemaining, "%s", true)
                views.setChronometerCountDown(R.id.widget_chronometer, true)
            } else {
                views.setTextViewText(R.id.widget_chronometer, "00:00:00")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }
    }
}
